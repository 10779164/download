#---------------------------------------------------------------------
# Function: Install Postfix
#    Install and configure postfix
#---------------------------------------------------------------------
InstallPostfix() {
  echo -e "Checking and disabling sendmail...\n"
  systemctl stop sendmail.service > /dev/null 2>&1
  systemctl disable sendmail.service > /dev/null 2>&1
  echo -e "Installing postfix... \n"
  yum -y install postfix ntp getmail > /dev/null 2>&1

  openssl req -new -outform PEM -out /etc/postfix/smtpd.cert -newkey rsa:2048 -nodes -keyout /etc/postfix/smtpd.key -keyform PEM -days 3650 -x509 -subj "/CN=$SSL_COUNTRY/ST=$SSL_STATE/L=$SSL_LOCALITY/O=$SSL_ORGANIZATION/OU=$SSL_ORGUNIT/CN=$CFG_HOSTNAME_FQDN/emailAddress=support@databasemart.com"

  systemctl enable postfix.service > /dev/null 2>&1
  systemctl restart postfix.service > /dev/null 2>&1
  echo -e "${green}done${NC}\n"
}
