#!/bin/sh
#script for checking whether postfix(smtp) is up or not, if not working then check why and if it is not installed installing it

#checking the status of postfix
a=`systemctl status postfix | grep "active"`
if [ $a == "active"]
	then
	echo "postfix is installed and running"
else
#creating function for postfix restart and installation
	Mailcheck ()
		{
#restarting the postfix 
		systemctl restart postfix -y
#checking the execution of the last command whether it is successful or not
		if [ $? == 0 ]
			then
			echo "postfix restarted successfully"
		else
#installing postfix
			yum install postfix
#checking the status of last executed command
				if [ $? == 0 ]
					then
#if successfull then change the fields in the main.cf file for smooth installation

#removing the hash symbol and adding the confriguation host name 
					sed -n '75,75 p' /etc/potsfix/main.cf | sed 's/^\(\#\)*//' | awk -F'=' '{print $1"=ankit@npmjs.com"}'
#removing the hash symbol and adding the parent host name 
					sed -n '83,83 p' /etc/potsfix/main.cf | sed 's/^\(\#\)*//' | awk -F'=' '{print $1"=npmjs.com"}'
#removing the hash symbol
					sed -n '99,99 p' /etc/potsfix/main.cf | sed 's/^\(\#\)*//'
#removing the hash symbol
					sed -n '113,113 p' /etc/potsfix/main.cf | sed 's/^\(\#\)*//'
#removing the hash symbol
					sed -n '116,116 p' /etc/potsfix/main.cf | sed 's/^\(\#\)*//'
#removing the hash symbol
					sed -n '264,264 p' /etc/potsfix/main.cf | sed 's/^\(\#\)*//'
#removing the hash symbol
					sed -n '426,426 p' /etc/potsfix/main.cf | sed 's/^\(\#\)*//'
#starting the postfix without options
					systemctl start postfix -y
#adding the service of firewall
					firewall-cmd --permanent --add-service=smtp
#checking the status of the postfix after installing it and starting it
					c=`systemctl status postfix | grep "active"`
						if [ $c == "active"]
							then
							echo "postfix is installed and running"
						fi
				fi
		fi
		}
#testing the mail functionality, if working it will exit with status 0 but if it fails calling mailcheck function to restart it or again installing it
mail -s "this is a test mail" ankit@npmjs.com
	if [ $? == 1 ]
		mailcheck
	fi
fi

#scheduling cron job and storing it
echo "*/5 	*	*	*	*	$0 | tee -a /var/spool/cron/root"
#to make the setup of cron active, restarting crontab
systemctl restart crontab