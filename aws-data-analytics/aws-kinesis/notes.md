
## References
- Setting up IAM roles
https://kulasangar.medium.com/creating-and-attaching-an-aws-iam-role-with-a-policy-to-an-ec2-instance-using-terraform-scripts-aa85f3e6dfff

- Invoking start_up script in EC2 instance
https://fabianlee.org/2021/05/28/terraform-invoking-a-startup-script-for-an-ec2-aws_instance/


## Configure kinesis by terraform

- In current directory run the following commands.
```shell
export AWS_ACCESS_KEY_ID=$(env | grep AWS_ACCESS_KEY_ID | cut -d '=' -f 2)
export AWS_SECRET_ACCESS_KEY=$(env | grep AWS_SECRET_ACCESS_KEY | cut -d '=' -f 2)
export AWS_DEFAULT_REGION=$(env | grep AWS_DEFAULT_REGION | cut -d '=' -f 2)
cd aws-data-analytics/aws-kinesis
terraform init
terraform plan

# Get inside ec2-instance
cd ~/.ssh
ssh -i aws-rcp-test.pem ec2-user@13.126.148.194
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
sudo ./LogGenerator.py

# tail -f /var/log/aws-kinesis-agent/aws-kinesis-agent.log
```