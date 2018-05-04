#/bin/bash

kubectl create secret docker-registry myregistrykey \
> --docker-server=https://index.docker.io/v1/ \
> --docker-username=dockerhubusername \
> --docker-password=dockerhubpassword \
> --docker-email=youremailn@gmail.com

secret "myregistrykey" created