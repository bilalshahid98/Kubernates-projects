1️⃣ Deploy Argo CD on Kubernetes
kubectl create namespace argocd

---
Step 2: Install Argo CD
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

---
Step 3: Expose Argo CD API server
kubectl port-forward --address 0.0.0.0 svc/argocd-server -n argocd 8000:443

---
Option B: LoadBalancer (production)
apiVersion: v1
kind: Service
metadata:
  name: argocd-server
  namespace: argocd
spec:
  type: LoadBalancer
  ports:
    - port: 443
      targetPort: 8080
  selector:
    app.kubernetes.io/name: argocd-server

---
Step 4: Get the admin password
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d

---
Step 5: Install Argo CD CLI (optional but recommended)

# MacOS
brew install argocd

# Linux
curl -sSL -o /usr/local/bin/argocd https://github.com/argoproj/argo-cd/releases/latest/download/argocd-linux-amd64
chmod +x /usr/local/bin/argocd

argocd login <ARGOCD_SERVER> --username admin --password <PASSWORD>

---
2️⃣ Create your first application

kubectl apply -f - <<EOF
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: guestbook
  namespace: argocd
spec:
  project: default
  source:
    repoURL: https://github.com/argoproj/argocd-example-apps.git
    targetRevision: HEAD
    path: guestbook
  destination:
    server: https://kubernetes.default.svc
    namespace: default
  syncPolicy:
    automated:
      prune: true
      selfHeal: true
EOF
---
3️⃣ Advanced Concepts
Each environment (dev, staging, prod) should have its own Git repo or branch.

Argo CD acts as the single source of truth: the cluster state must match Git.

# add the github repo which is using a ssh

argocd repo add git@github.com:my-org/myapp.git \
  --ssh-private-key-path ~/.ssh/id_rsa_argocd


argocd repo add git@github.com:Ascend-Developers/DevOps-Research-Development.git \
  --ssh-private-key-path ~/.ssh/id_rsa

argocd repo list


B. Projects

apiVersion: argoproj.io/v1alpha1
kind: AppProject
metadata:
  name: prod
  namespace: argocd
spec:
  description: "Development environment"
  sourceRepos:
    - git@github.com:Ascend-Developers/DevOps-Research-Development.git
  destinations:
    - namespace: prod
      server: https://kubernetes.default.svc

---
5️⃣ Applications using SSH repo
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: myapp-dev
  namespace: argocd
spec:
  project: dev
  source:
    repoURL: git@github.com:my-org/myapp.git
    targetRevision: HEAD
    path: dev
  destination:
    server: https://kubernetes.default.svc
    namespace: dev
  syncPolicy:
    automated:
      prune: true
      selfHeal: true

---
C. Sync Waves & Hooks
Control deployment order using waves and pre/post-sync hooks:

syncPolicy:
  automated:
    prune: true
  syncOptions:
    - CreateNamespace=true
  hooks:
    - type: PreSync
      command: ["/bin/sh", "-c", "echo PreSync Hook"]

---
D. Argo CD Notifications

Send alerts on app health/sync events (Slack, MS Teams, email):
argocd-notifications-cm.yaml

