#/bin/bash

kubectl create secret docker-registry myregistrykey \
> --docker-server=https://index.docker.io/v1/ \
> --docker-username=supersid \
> --docker-password=theholygrail \
> --docker-email=sid.ravichandran@gmail.com

secret "myregistrykey" created