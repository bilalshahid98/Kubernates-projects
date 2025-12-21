## 📌 Meaning:

## Kubernetes will reject unsafe pods

Your deployment must comply
kubectl label ns prod \
pod-security.kubernetes.io/enforce=restricted \
pod-security.kubernetes.io/enforce-version=latest
