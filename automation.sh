#!/bin/bash

timestamp=$(date '+%d%m%Y-%H%M%S')
s3_bucket=upgrad-jayeshkumar
myname=jayeshkumar

sudo apt update -y #update the package information
apache2 -v > /dev/null

if [ $? -eq 0 ]
then
echo "apache2 is alraedy installed"
else
sudo apt install apache2 -y
fi

sudo apt install awscli -y

var=$(systemctl is-enabled apache2)
var1=$(systemctl is-active apache2)

if [ $var1 != "active" ]
then
sudo systemctl start apache2
else
echo "Apache2 already active"
fi

if [ $var != "enabled" ]
then
sudo systemctl enable apache2
else
echo "Apache2 Already enabled"
fi

cd /var/log/apache2/
tar -cvf /tmp/jayeshkumar-httpd-logs-${timestamp}.tar *log
aws s3 cp /tmp/${myname}-httpd-logs-${timestamp}.tar s3://${s3_bucket}/${myname}-httpd-logs-${timestamp}.tar
