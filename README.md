# ldap_login (An inside IIT Bombay application)
Login into internet.iitb.ac.in seamlessly in Linux servers which doesn't have a desktop interface to use browsers.

## Usage: `ldap_login command`

Commands:

	status : check login status

	login : login into internet.iitb.ac.in

	logout : logout into internet.iitb.ac.in
	
## Examples: 

- `ldap_login status` outputs the following if logged in:

		Status: Logged in

		LDAP ID     IP ADDRESS    LOCATION   LOGIN TIME
		150050091   10.9.160.13   Hostel-9   19-Mar-2019 22:06:23

	`ldap_login status` outputs the following if logged out:

		Status: Logged out

- `ldap_login login` authenticates the LDAP user and logins him/her

- `ldap_login logout` logouts the user

## Installation
Go to 'ldap_login' directory and execute ldap_login.sh
- `cd ldap_login`
- `./install`
