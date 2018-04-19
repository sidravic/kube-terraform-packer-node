#!/bin/bash

export MASTER_IP=159.89.167.107

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

# This advertises the master IP address which is a public IP
# The --pod-network-cidr
#      --pod-network-cidr string      Specify range of IP addresses for the pod network. If set, the control plane will automatically allocate CIDRs for every node.
kubeadm init --pod-network-cidr=10.244.0.0/16 --apiserver-advertise-address $MASTER_IP

#Response
mkdir -p $HOME/.kube
  sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
  sudo chown $(id -u):$(id -g) $HOME/.kube/config
kubeadm join 159.89.167.107:6443 --token qok08g.qgdsz9gcdb6l5tda --discovery-token-ca-cert-hash sha256:190eccb58133295559571c0ff6b86dc5b6370d1df921968abb027fd1e07675a7

# Install flannel for networking overlay
curl -sSL "https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml" | kubectl --namespace=kube-system create -f -

#Install a dashboard
#kubectl create -f https://rawgit.com/kubernetes/dashboard/master/src/deploy/kubernetes-dashboard.yaml --namespace=kube-system 
#The line above doesn't work

kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/master/src/deploy/recommended/kubernetes-dashboard.yaml