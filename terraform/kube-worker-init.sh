#!/bin/bash

# add ssh key to authorized keys
chmod 600 /root/.ssh/id_rsa.pub /root/.ssh/id_rsa
scp -q -o "StrictHostKeyChecking=no" root@$MASTER_IP:/root/output.txt /root/output.txt
tail -3 output.txt >> output.sh
chmod +x output.sh
./output.sh