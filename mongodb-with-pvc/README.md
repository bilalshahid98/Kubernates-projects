Run the commands in a sequance 
kubectl apply -f storageclass.yaml
kubectl apply -f pv.yaml
kubectl apply -f pvc.yaml
kubectl apply -f statefulset.yaml
kubectl apply -f service.yaml

8️⃣ Initialize ReplicaSet (ONE-TIME STEP)
kubectl exec -it -n prod mongodb-0 -- mongosh \
  -u admin -p strongpassword123 --authenticationDatabase admin


rs.initiate({
  _id: "rs0",
  members: [
    { _id: 0, host: "mongodb-0.mongodb.prod.svc.cluster.local:27017" },
    { _id: 1, host: "mongodb-1.mongodb.prod.svc.cluster.local:27017" },
    { _id: 2, host: "mongodb-2.mongodb.prod.svc.cluster.local:27017" }
  ]
})


rs.status()

