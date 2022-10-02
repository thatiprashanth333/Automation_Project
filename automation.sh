#!/bin/bash

# Variables
name="thati"
s3_bucket="upgrad-thati"
timestamp=$(date '+%d%m%Y-%H%M%S')
logtype='httpd-logs'
Datecreated=$(date +"%d%m%Y-%H%M%S")
type='tar'


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


docroot="/var/www/html"
# Check if inventory file exists
if [ -f "/var/www/html/inventory.html" ]
then
echo "File is found"
else

        echo "File creating ..........."
	
echo -e 'Log Type\t-\tTime Created\t-\tType\t-\tSize' > ${docroot}/inventory.html

fi

# Inserting Logs into the file
if [[ -f ${docroot}/inventory.html ]]; then
	#statements
    size=$(du -h /tmp/${name}-httpd-logs-${timestamp}.tar | awk '{print $1}')

echo -e "$logtype\t-\t${timestamp}\t-\t$type\t-\t${size}" >> ${docroot}/inventory.html

fi

# Create a cron job that runs service at an interval of 1 day
if [[ ! -f /etc/cron.d/automation ]]; then
	echo "0 0 * * * root /root/automation.sh" >> /etc/cron.d/automation
fi

