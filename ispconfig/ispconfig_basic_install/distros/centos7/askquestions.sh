#---------------------------------------------------------------------
# Function: AskQuestions
#    Ask for all needed user input
#---------------------------------------------------------------------
AskQuestions() {
	  echo "Installing pre-required packages"
	  [ -f /bin/whiptail ] && echo -e "whiptail found: ${green}OK${NC}\n"  || yum -y install newt

	  while [ "x$CFG_MYSQL_ROOT_PWD" == "x" ]
	  do
		CFG_MYSQL_ROOT_PWD=$(whiptail --title "MySQL root password" --backtitle "$WT_BACKTITLE" --inputbox "Please specify a root password for MySQL~" --nocancel 10 50 3>&1 1>&2 2>&3)
	  done

	  while [ "x$CFG_WEBSERVER" == "x" ]
          do
		#CFG_PHPVERSION=$(whiptail --title "WEBSERVER" --backtitle "$WT_BACKTITLE" --nocancel --radiolist "Select php version" 10 50 4 "php7.0" "default" ON "php5.4" "" OFF "php7.1" "" OFF "php7.2" ""  OFF 3>&1 1>&2 2>&3)
                CFG_WEBSERVER=$(whiptail --title "WEBSERVER" --backtitle "$WT_BACKTITLE" --nocancel --radiolist "Select webserver type" 10 50 2 "apache" "default" ON "nginx" "Unimplemented" OFF 3>&1 1>&2 2>&3)
          done
	
		CFG_JKIT="yes"
		CFG_DKIM="y"
		CFG_PHPMYADMIN="yes"

      		SSL_COUNTRY="EN"
      		SSL_STATE="USA"
      		SSL_LOCALITY="Texas"
      		SSL_ORGANIZATION="DBM"
      		SSL_ORGUNIT="IT"

      CFG_ISPCONFIG_PWD=$(whiptail --title "ISPConfig admin password" --backtitle "$WT_BACKTITLE" --inputbox "Please specify admin's password for ISPConfig~" --nocancel 10 50 3>&1 1>&2 2>&3)
}

