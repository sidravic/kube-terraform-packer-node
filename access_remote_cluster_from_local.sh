#!/bin/bash

export MASTER_IP=159.89.167.107
scp root@$MASTER_IP:/etc/kubernetes/admin.conf .


cp admin.conf ~/.kube/config