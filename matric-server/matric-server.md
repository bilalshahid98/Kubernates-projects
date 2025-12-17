

# 📊 Metrics Server Installation on KIND Cluster

This guide explains how to install **Kubernetes Metrics Server** on a **kind (Kubernetes in Docker)** cluster.

> ⚠️ **Important:** kind clusters require additional flags because kubelet certificates are self-signed.

---

## ✅ Prerequisites

* kind cluster running
* `kubectl` configured
* Internet access to download manifests

---

## 🚀 Installation Steps

---

### 🔹 Step 1: Download Metrics Server Manifest

```bash
curl -LO https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml
```

---

### 🔹 Step 2: Edit the Manifest (Mandatory for KIND)

Open the file:

```bash
vi components.yaml
```

Locate the **metrics-server Deployment** and update the container arguments.

#### ❌ Before

```yaml
args:
  - --cert-dir=/tmp
  - --secure-port=10250
```

#### ✅ After (Add required flags)

```yaml
args:
  - --cert-dir=/tmp
  - --secure-port=10250
  - --kubelet-insecure-tls
  - --kubelet-preferred-address-types=InternalIP,ExternalIP,Hostname
```

📌 These flags allow Metrics Server to communicate with kubelets in kind.

---

### 🔹 Step 3: Apply the Manifest

```bash
kubectl apply -f components.yaml
```

---

### 🔹 Step 4: Verify Metrics Server Pod

```bash
kubectl get pods -n kube-system
```

Expected output:

```bash
metrics-server-xxxxxxx   1/1   Running
```

---

### 🔹 Step 5: Test Metrics API

Wait **30–60 seconds**, then run:

```bash
kubectl top nodes
kubectl top pods
```

✔️ If CPU and memory values appear, Metrics Server is working correctly.

---

## ❗ Common Errors & Fixes

### ❌ `Metrics API not available`

* Wait 1 minute and retry

### ❌ `x509: certificate signed by unknown authority`

* Ensure `--kubelet-insecure-tls` is present in args

---

## 🧠 Why Extra Configuration is Required in KIND?

| Problem             | Reason                                      |
| ------------------- | ------------------------------------------- |
| TLS errors          | kubelets use self-signed certificates       |
| Metrics unavailable | Metrics Server cannot authenticate kubelets |

---

## 🧾 Summary

```bash
curl -LO components.yaml
edit → add insecure TLS flags
kubectl apply -f components.yaml
kubectl top nodes
```

---

## 📌 Optional Enhancements

* Enable **Horizontal Pod Autoscaler (HPA)**
* Use Metrics Server with **KIND autoscaling tests**
* Patch manifest automatically using `kustomize`

---

## 📚 References

* Kubernetes Metrics Server
* kind Kubernetes Cluster
* `kubectl top`

