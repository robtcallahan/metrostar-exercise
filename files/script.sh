#!/bin/bash

sudo yum update -y

sudo yum install -y httpd
sudo yum install -y mysql
sudo yum install -y php
sudo yum install -y php-mysql

sudo mkdir /var/lib/mysql
sudo touch /var/log/php_errors.log
sudo chown apache.apache /var/log/php_errors.log

sudo cp /tmp/index.php /var/www/html/index.php
sudo cp /tmp/php.ini /etc/php.ini

sudo service httpd start

echo $1 $2

mysql -h terraform-20180311214716858100000001.ciceqbkiriam.us-east-1.rds.amazonaws.com --user=$1 --password=$2 </tmp/user_table.sql

