#!/bin/bash

sudo yum install -y aws-kinesis-agent
cd /tmp
mkdir big-data
cd big-data
wget http://media.sundog-soft.com/AWSBigData/LogGenerator.zip
unzip LogGenerator.zip
chmod a+x LogGenerator.py
sudo mkdir /var/log/cadabra