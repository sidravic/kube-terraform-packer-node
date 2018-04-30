#!/bin/bash

echo "Starting user data execution"

IP_ADDRESS=$(ifconfig eth0 | grep 'inet addr'| cut -d: -f2 | awk '{print $1}')
export MASTER_IP=$IP_ADDRESS

kubeadm init --pod-network-cidr=10.244.0.0/16 --apiserver-advertise-address $MASTER_IP > output.txt

mkdir -p $HOME/.kube
cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
chown $(id -u):$(id -g) $HOME/.kube/config


curl -sSL "https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml" | kubectl --namespace=kube-system create -f -

kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/master/src/deploy/recommended/kubernetes-dashboard.yaml
echo "ending user data execution"