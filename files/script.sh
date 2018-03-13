#!/bin/bash

user=$1
pwd=$2

# update the OS packages
sudo yum update -y

# install required software
echo "yum install -y httpd"
sudo yum install -y httpd
echo "yum install -y mysql"
sudo yum install -y mysql
echo "yum install -y php"
sudo yum install -y php
echo "yum install -y php-mysql"
sudo yum install -y php-mysql
echo "yum install -y jq"
sudo yum install -y jq

# create and set perms on PHP log file
echo "Creating php_errors.log"
sudo mkdir /var/lib/mysql
sudo touch /var/log/php_errors.log
sudo chown apache.apache /var/log/php_errors.log

# Move the index.php in place
echo "Copying index.php..."
sudo cp /tmp/index.php /var/www/html/index.php
sudo cp /tmp/php.ini /etc/php.ini

# Put the aws credentials in place
echo "copying aws credentials to ~/.aws"
sudo mkdir /home/ec2-user/.aws
sudo cp /tmp/config /tmp/credentials /home/ec2-user/.aws
sudo chown -R ec2-user /home/ec2-user/.aws
sudo chgrp -R ec2-user /home/ec2-user/.aws

# Put the instance key pair in place
echo "copying robs-mbp.pem to ~/.ssh"
sudo cp /tmp/robs-mbp.pem /home/ec2-user/.ssh
sudo chown -R ec2-user /home/ec2-user/.ssh
sudo chgrp -R ec2-user /home/ec2-user/.ssh

# install aws cli
echo "Installating the AWS CLI"
cd ~
curl "https://s3.amazonaws.com/aws-cli/awscli-bundle.zip" -o "awscli-bundle.zip"
unzip awscli-bundle.zip
sudo ./awscli-bundle/install -i /usr/local/aws -b /usr/local/bin/aws
rm -rf awscli-bundle*

# Get the webdb endpoint address and update the index.php with this value
echo "Updating index.php with new RDS endpoint"
db_endpoint=$(aws rds describe-db-instances --query 'DBInstances[?DBName==`webdb`]' | jq .[0].Endpoint.Address)
db_endpoint=`echo ${db_endpoint} | sed -e 's/"//g'`
echo "        new endpoint = ${db_endpoint}"
sudo sed -i"" "s/db_endpoint/${db_endpoint}/g" /var/www/html/index.php

# Run the user_table.sql to create the user table and insert a row
echo "Updating the Mysql database"
mysql -h ${db_endpoint} --user=${user} --password=${pwd} </tmp/user_table.sql

# start apache
echo "starting httpd"
sudo service httpd start

# clean up tmp
echo "Cleaning up"
cd /tmp
sudo rm -r config credentials robs-mbp.pem index.php php.ini user_table.sql script.sh



