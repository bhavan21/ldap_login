#!/bin/bash

login (){
	status="1"
	while [ "$status" -eq "1" ]; do
		printf "Enter LDAP User Name:"
		read uname
		printf "Enter LDAP Password:"
		read -s passwd
		echo ""
		page=`curl -s --data "uname=$uname&passwd=$passwd"   https://internet.iitb.ac.in/index.php`
		status=`echo $page|grep -c 'badpw' `
		if [ "$status" -eq "1" ]; then
			echo "Bad Username or Password! Please try again."
		fi
	done
	status=`echo $page|grep -c 'logout' `
	if [ "$status" -eq "1" ]; then
		echo "Logged in successfully"
	else
		echo "Already logged in by another user"
	fi
}

logout (){
	page=`curl -s --data "ip=$1&button=Logout" https://internet.iitb.ac.in/logout.php`
	status=`echo $page|grep -c 'logout' `
	if [ "$status" -eq "1" ] 
	then
		echo "Logged out successfully"
	else
		echo "Already logged out"
	fi

	
}

status_check (){
	page=`curl -s  https://internet.iitb.ac.in/logout.php`
	logged_in=`echo $page|grep -c 'login' `
	if [ "$logged_in" -eq "1" ]
		then
			echo "Status: Logged in"
			echo ""
			# Login details
			login_details=`echo $page | awk -F'checked="checked"' '{print $1}'  |  grep -o -P '(?<=<center> ).*?(?=</center>)' | tail -4`
			# s=${login_details//[[:blank:]]/}
			s=$login_details
			printf "LDAP ID,IP ADDRESS,LOCATION,LOGIN TIME\n`echo "$s" | sed -n 1p`,`echo "$s" | sed -n 2p`,`echo "$s" | sed -n 3p`,`echo "$s" | sed -n 4p`\n" | column -t -s','

		else
			echo "Status: Not logged in"
	fi
}

if [ "$1" = "-v" -o "$1" = "--version" ]; then
	echo "1.0"
elif [ "$1" = "status" ]; then
	status_check
elif [ "$1" = "login" ]; then
	page=`curl -s  https://internet.iitb.ac.in/logout.php`

	# check if already logged in
	logged_in=`echo $page|grep -c 'login' `
	if [ "$logged_in" -eq "1" ]; then
		echo "Already logged in by another user"
	else
		login
	fi

elif [ "$1" = "logout" ]; then
	page=`curl -s  https://internet.iitb.ac.in/logout.php`

	# check if already logged out
	logged_in=`echo $page|grep -c 'login' `
	if [ "$logged_in" -eq "1" ]
		then
			# get current ip address from list of all ips loggedin by the user
			ip=`echo $page|grep -o '"'[.0-9]*'" checked="checked"' | grep -o [.0-9]*`
			logout $ip
		else
			echo "Already logged out"
	fi
else
	echo '''Usage: ldap_login command

Commands:
	status : check login status

	login : login into internet.iitb.ac.in

	logout : logout into internet.iitb.ac.in
'''
fi
