<!-- Pod Priority: Assigns a priority value to pods. Higher value = more important.

Preemption: If a high-priority pod cannot be scheduled because of lack of resources, Kubernetes evicts lower-priority pods to make room.

This is critical in multi-tenant clusters, or when production and non-production workloads share nodes.

# How It Works in Production

Scenario:

Cluster has 3 nodes, each can run 2 pods.

Node resources are full with dev/test pods (low priority).

A production pod (high priority) is created.

Without priority → pod stays pending.
With Pod Priority & Preemption → Kubernetes evicts low-priority pods to schedule the high-priority pod immediately. -->