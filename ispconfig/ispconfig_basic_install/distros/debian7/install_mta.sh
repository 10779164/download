#---------------------------------------------------------------------
# Function: InstallMTA
#    Install chosen MTA. Courier or Dovecot
#---------------------------------------------------------------------
InstallMTA() {
	  echo -n "Installing dovecot... ";
	  apt-get -qqy install dovecot-imapd dovecot-pop3d dovecot-sieve dovecot-mysql > /dev/null 2>&1
	  echo -e "${green}done! ${NC}\n"
}
