#!/bin/bash

# Variables
name="thati"
s3_bucket="upgrad-thati"
timestamp=$(date '+%d%m%Y-%H%M%S')

echo "=========== Updating the Ubuntu Repositories ================="
sudo apt update -y

echo "============== Verifying & Installing apache2 ================"
if [[ apache2 != $(dpkg --get-selections apache2 | awk '{print $1}') ]]; then
	echo "Installing"
	sudo apt install apache2 -y
fi

echo "============= Checking apache2 is running or not ============="
running=$(systemctl status apache2 | grep active | awk '{print $3}' | tr -d '()')
if [[ running != ${running} ]]; then
	systemctl start apache2
fi

echo "============= Checking apache2 is enabled or not =============" 
enabled=$(systemctl is-enabled apache2 | grep "enabled")
if [[ enabled != ${enabled} ]]; then
	echo "enabling"
	systemctl enable apache2
fi

echo "============= Creating tar archive of apache2 access and error logs =============="
cd /var/log/apache2
tar -cf /tmp/${name}-httpd-logs-${timestamp}.tar *.log

echo "================= Copying logs to s3 bucket =================="
if [[ -f /tmp/${name}-httpd-logs-${timestamp}.tar ]]; then
	aws s3 cp /tmp/${name}-httpd-logs-${timestamp}.tar s3://${s3_bucket}/${name}-httpd-logs-${timestamp}.tar
fi

