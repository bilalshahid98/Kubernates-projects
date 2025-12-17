kubectl apply -f nginx-pod.yaml

kubectl get pods -n prod

kubectl port-forward pod/nginx-pod 8080:80 -n prod
