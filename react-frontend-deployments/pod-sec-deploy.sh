apiVersion: apps/v1
kind: Deployment
metadata:
  name: react-frontend
  namespace: prod
spec:
  replicas: 2
  selector:
    matchLabels:
      app: react-frontend
  template:
    metadata:
      labels:
        app: react-frontend
    spec:
      # Pod-level security context (applied to all containers)
      securityContext:
        runAsNonRoot: true               # ❌ Prevent pod from running as root
        runAsUser: 1000                  # ✅ Run as non-root app user
        seccompProfile:
          type: RuntimeDefault           # ✅ Restrict syscalls (required for restricted PodSecurity)

      containers:
        - name: react-frontend
          image: k8s-react:v1.0.0        # ✅ Use fixed image, avoid 'latest'
          imagePullPolicy: IfNotPresent   # ✅ Pull only if not present
          ports:
            - containerPort: 80

          # Container-level security context
          securityContext:
            allowPrivilegeEscalation: false   # ❌ Prevent privilege escalation
            readOnlyRootFilesystem: true     # ❌ Prevent filesystem tampering
            capabilities:
              drop:
                - ALL                        # ❌ Drop all Linux capabilities (least privilege)

          # Resource Management
          resources:
            requests:
              cpu: "100m"                     # 🔹 Minimum CPU requested
              memory: "128Mi"                 # 🔹 Minimum memory requested
            limits:
              cpu: "200m"                     # 🔹 Maximum CPU allowed
              memory: "256Mi"                 # 🔹 Maximum memory allowed

          # Health checks
          livenessProbe:
            httpGet:
              path: /                        # ✅ Endpoint to check if pod is alive
              port: 80
            initialDelaySeconds: 10          # ⏱ Wait 10s before first liveness check
            periodSeconds: 10                # ⏱ Check every 10s

          readinessProbe:
            httpGet:
              path: /                        # ✅ Endpoint to check if pod is ready to serve traffic
              port: 80
            initialDelaySeconds: 5           # ⏱ Wait 5s before first readiness check
            periodSeconds: 5                 # ⏱ Check every 5s
