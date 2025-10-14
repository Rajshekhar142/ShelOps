# ShelOps
Shell Scripting for DevOps

# 🚀 Creating and Managing Pods

# Create the Pod
kubectl apply -f nginx-pod.yaml

# View Pods
kubectl get pods

# Detailed info
kubectl describe pod nginx-pod

# View logs
kubectl logs nginx-pod

# Execute commands inside
kubectl exec -it nginx-pod -- /bin/bash

# Delete the Pod
kubectl delete pod nginx-pod