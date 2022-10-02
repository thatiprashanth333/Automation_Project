
# Automation_Project

# Task 2
1. This script will first perform the task of update by "apt update" command.
2. Then it will check for apache2 is installed or not. If it is not installed it will install for us.
3. It will check the status of apache2 if it is "running" proceed further. If not restart apache2 server with the command we given.
4. In order to maintain apache2 running after restarts or reboot of system. It willl enable it. if not enabled.
5. It will collect the logs in /var/log/apache2/ directory make a tar folder using all .log files and save it in /tmp/ directory.
6. It will copy tar files to s3 bucket.

# Task 3
7. It will display the logs as using inventory.html
8. Display as below
Log Type	-	Time Created	-	Type	-	Size

httpd-logs	-	02102022-124949	-	tar	-	12K

httpd-logs	-	02102022-124957	-	tar	-	12K

httpd-logs	-	02102022-125002	-	tar	-	12K

httpd-logs	-	02102022-125007	-	tar	-	12K

9. Finally it will schedule a cronjob that runs the same script automatically at an interval of 1 day as a root user.
