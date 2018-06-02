#---------------------------------------------------------------------
# Function: InstallMTA Ubutu 16.04
#    Install MTA Dovecot
#---------------------------------------------------------------------
InstallMTA() {
	  echo -n "Installing Dovecot... ";
	  echo "dovecot-core dovecot-core/create-ssl-cert boolean false" | debconf-set-selections
	  echo "dovecot-core dovecot-core/ssl-cert-name string $CFG_HOSTNAME_FQDN" | debconf-set-selections
	  apt-get -yqq install dovecot-imapd dovecot-pop3d dovecot-mysql dovecot-sieve dovecot-lmtpd opendkim opendkim-tools > /dev/null 2>&1
	  echo -e "[${green}DONE${NC}]\n"
}
