#---------------------------------------------------------------------
# Function: InstallMTA
#    Install MTA. Dovecot
#---------------------------------------------------------------------
InstallMTA() {
	echo -n "Installing dovecot... ";
	yum -y install dovecot dovecot-mysql dovecot-pigeonhole > /dev/null 2>&1
	touch /etc/dovecot/dovecot-sql.conf  > /dev/null 2>&1
	ln -s /etc/dovecot/dovecot-sql.conf /etc/dovecot-sql.conf  > /dev/null 2>&1
	systemctl enable dovecot > /dev/null 2>&1
      	systemctl start dovecot > /dev/null 2>&1
	echo -e "${green}done! ${NC}\n"
}
