#!/bin/bash

apt-get update && apt-get upgrade -y

# adds google cloud platform key. Allows fetching stuff from googlecloudplatform
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -

# Add this to the packages
cat <<EOF > /etc/apt/sources.list.d/kubernetes.list
deb http://apt.kubernetes.io/ kubernetes-xenial main
EOF

apt-get update -y

apt-get install -y docker.io

#kubernetes-cni 
#is the kubernetes container networking interface which is responsible for setting up the entire container networking overlay

#kubeadm
# This allows us to bootstrap a kubernetes cluster
# Example usage:

#     Create a two-machine cluster with one master (which controls the cluster),
#     and one node (where your workloads, like Pods and Deployments run).

#     ┌──────────────────────────────────────────────────────────┐
#     │ On the first machine:                                    │
#     ├──────────────────────────────────────────────────────────┤
#     │ master# kubeadm init                                     │
#     └──────────────────────────────────────────────────────────┘

#     ┌──────────────────────────────────────────────────────────┐
#     │ On the second machine:                                   │
#     ├──────────────────────────────────────────────────────────┤
#     │ node# kubeadm join <arguments-returned-from-init>        │
#     └──────────────────────────────────────────────────────────┘

#     You can then repeat the second step on as many other machines as you like.

apt-get install -y kubelet kubeadm kubectl kubernetes-cni

kubeadm join master_ip:6443 --token qok08g.qgdsz9asdasdsdgcdb6l5tda --discovery-token-ca-cert-hash sha256:190ecasdasdascb58randomTokenStringc0ff6b86dc5b6370d1df921968asdasdabb027fd1e07675a7