
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

```