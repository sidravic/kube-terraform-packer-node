IP_ADDRESS=$(ifconfig eth0 | grep 'inet addr'| cut -d: -f2 | awk '{print $1}')
export MASTER_IP=$IP_ADDRESS

kubeadm init --pod-network-cidr=10.244.0.0/16 --apiserver-advertise-address $MASTER_IP