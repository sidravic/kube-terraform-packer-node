# Component status
kube get cs 

#Cluster info
kubectl cluster-info

# Get Nodes
kubectl get nodes


# Get pods logs
kubectl logs <podname>
kubectl logs web

#insights into the pod
kubectl describe pod


# applying updates to deployments
kubectl create -f kube-deploy/chomeshvan-deployments.yml
#lets say you make a change to the version number and then.
kubectl apply -f chomeshvan-deployment.yml

#Delete a node from Kubernetes 
kubectl drain <node name> --delete-local-data --force --ignore-daemonsets
kubectl delete node <node name>


