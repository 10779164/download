#---------------------------------------------------------------------
# Function: AskQuestions Ubuntu 16.04
#    Ask for all needed user input
#---------------------------------------------------------------------
AskQuestions() {
	  echo "Installing pre-required packages"
	  [ -f /bin/whiptail ] && echo -e "whiptail found: ${green}OK${NC}\n"  || apt-get -y install whiptail > /dev/null 2>&1
	  
                CFG_SQLSERVER="MySQL"
		  
	  while [ "x$CFG_MYSQL_ROOT_PWD" == "x" ]
	  do
		CFG_MYSQL_ROOT_PWD=$(whiptail --title "MySQL" --backtitle "$WT_BACKTITLE" --inputbox "Please specify a root password" --nocancel 10 50 3>&1 1>&2 2>&3)
	  done

	  while [ "x$CFG_WEBSERVER" == "x" ]
          do
                CFG_WEBSERVER=$(whiptail --title "WEBSERVER" --backtitle "$WT_BACKTITLE" --nocancel --radiolist "Select webserver type" 10 50 2 "apache" "(default)" ON "nginx" "" OFF 3>&1 1>&2 2>&3)
          done

	   	CFG_XCACHE="yes"
                CFG_PHPMYADMIN="yes"
                CFG_ISPC="standard"
                CFG_JKIT="yes"

                SSL_COUNTRY="EN"
                SSL_STATE="USA"
                SSL_LOCALITY="Texas"
                SSL_ORGANIZATION="DBM"
                SSL_ORGUNIT="IT"	

      CFG_ISPCONFIG_PWD=$(whiptail --title "ISPConfig admin password" --backtitle "$WT_BACKTITLE" --inputbox "Please specify admin's password for ISPConfig~" --nocancel 10 50 3>&1 1>&2 2>&3)

}

