#!/usr/bin/env python

import os, errno, sys
import subprocess


# create directory if it doesn't exist
try:
    if not os.path.exists("/tmp/ssh"):
        os.makedirs("/tmp/ssh")
except OSError as e:
    if e.errno != errno.EEXIST:
        raise

#Check if file exists
try:
    if not os.path.isfile("/tmp/ssh/id_rsa.pub"):
        output = subprocess.check_output("ssh-keygen -b 2048 -t rsa -f /tmp/ssh/id_rsa -q -N \"\"", shell=True)
        print(output)
except:
    print "Unexpected error:", sys.exec_info()[0]
