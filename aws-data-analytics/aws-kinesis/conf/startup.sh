#!/bin/bash

sudo yum install -y aws-kinesis-agent
cd /tmp
mkdir big-data
cd big-data
wget http://media.sundog-soft.com/AWSBigData/LogGenerator.zip
unzip LogGenerator.zip
chmod a+x LogGenerator.py
sudo mkdir /var/log/cadabra

# Configure aws-kinesis
wget https://raw.githubusercontent.com/aankittcoolest/learn-data-analytics/main/aws-data-analytics/aws-kinesis/conf/agent.json

sudo mv agent.json /etc/aws-kinesis
sudo service aws-kinesis-agent restart
sudo chkconfig aws-kinesis-agent on