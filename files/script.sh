#!/bin/bash

# update the OS packages
sudo yum update -y

# install required software
sudo yum install -y httpd
sudo yum install -y mysql
sudo yum install -y php
sudo yum install -y php-mysql
sudo yum install -y jq

# create and set perms on PHP log file
sudo mkdir /var/lib/mysql
sudo touch /var/log/php_errors.log
sudo chown apache.apache /var/log/php_errors.log

# Move the index.php in place
sudo cp /tmp/index.php /var/www/html/index.php
sudo cp /tmp/php.ini /etc/php.ini

# Put the aws credentials in place
sudo mkdir /home/ec2-user/.aws
sudo cp /tmp/config /tmp/credentials /home/ec2-user/.aws
sudo chown -R ec2-user /home/ec2-user/.aws
sudo chgrp -R ec2-user /home/ec2-user/.aws

# Put the instance key pair in place
sudo cp /tmp/robs-mbp /home/ec2-user/.ssh
sudo chown -R ec2-user /home/ec2-user/.ssh
sudo chgrp -R ec2-user /home/ec2-user/.ssh

# Get the webdb endpoint address and update the index.php with this value
db_endpoint=$(aws rds describe-db-instances --query 'DBInstances[?DBName==`webdb`]' | jq .[0].Endpoint.Address)
sudo sed -i "" "s/db_endpoint/${db_endpoint}/g" /var/www/html/index.php

# Run the user_table.sql to create the user table and insert a row
mysql -h $db_endpoint --user=$1 --password=$2 </tmp/user_table.sql

# start apache
sudo service httpd start

# clean up tmp
cd /tmp
sudo rm -r config credentials robs-mbp index.php php.ini user_table.sql script.sh



