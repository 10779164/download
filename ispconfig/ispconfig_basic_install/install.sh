#!/usr/bin/env bash
#---------------------------------------------------------------------
# ISPConfig 3 system installer
# Script: install.sh
# Version: 3.0.2
# Description: This script will install all the packages needed to install
# ISPConfig 3 on your server.
#
#
#---------------------------------------------------------------------

#Those lines are for logging porpuses
exec > >(tee -i /var/log/ispconfig_setup.log)
exec 2>&1

#---------------------------------------------------------------------
# Global variables
#---------------------------------------------------------------------
CFG_HOSTNAME_FQDN=`hostname -f`;    
WT_BACKTITLE="ISPConfig 3 System Install"

# Bash Colour
red='\033[0;31m'
green='\033[0;32m'
NC='\033[0m' # No Color


#Saving current directory
PWD=$(pwd)
pwd=$(pwd)

#---------------------------------------------------------------------
# Load needed functions
#---------------------------------------------------------------------

source $PWD/functions/check_linux.sh    
echo "Checking your system, please wait..."
CheckLinux

#---------------------------------------------------------------------
# Load needed Modules
#---------------------------------------------------------------------

#Source install shell
source $PWD/distros/$DISTRO/preinstallcheck.sh  
source $PWD/distros/$DISTRO/askquestions.sh  

source $PWD/distros/$DISTRO/install_basics.sh 
source $PWD/distros/$DISTRO/install_mysql.sh  
source $PWD/distros/$DISTRO/install_webserver.sh  
source $PWD/distros/$DISTRO/install_ftp.sh  
source $PWD/distros/$DISTRO/install_quota.sh 
source $PWD/distros/$DISTRO/install_webstats.sh  
source $PWD/distros/$DISTRO/install_jailkit.sh 
source $PWD/distros/$DISTRO/install_ispconfig.sh 

#source $PWD/distros/$DISTRO/install_basephp.sh #to remove in feature release
#---------------------------------------------------------------------
# Main program [ main() ]
#    Run the installer
#---------------------------------------------------------------------
clear

echo "Welcome to ISPConfig Setup Script v.3.0.2"
echo "When this script starts running, it'll keep going all the way"
echo "So before you continue, please make sure the following checklist is ok:"
echo
echo "- This is a clean standard clean installation for supported systems";
echo "- Internet connection is working properly";
echo
echo
if [ -n "$PRETTY_NAME" ]; then
	echo -e "The detected Linux Distribution is: " $PRETTY_NAME
else
	echo -e "The detected Linux Distribution is: " $ID-$VERSION_ID
fi
echo
if [ -n "$DISTRO" ]; then
	echo -e "${green}Start install...${NC}"
else
	echo -e "${red}Sorry but your System is not supported by this script, if you want your system supported${NC}"
	exit 1
fi

if [ "$DISTRO" == "debian8" ]; then
        CFG_ISPCVERSION="Stable"
fi

if [ -f /etc/debian_version ]; then
  	PreInstallCheck
	AskQuestions
  	InstallBasics 
  	InstallSQLServer 
	InstallWebServer
    	InstallFTP 
    	InstallQuota 
    	InstallJailkit 
  	InstallWebStats
  	InstallISPConfig

  echo -e "${green}Well done ISPConfig installed and configured correctly :D ${NC}"
  echo -e "Now you can connect to your ISPConfig installation at ${green}https://$CFG_HOSTNAME_FQDN:8080 or https://IP_ADDRESS:8080${NC}"
  echo -e "Your ISPConfig admin's password is:${green}${CFG_ISPCONFIG_PWD}${NC}"
  if [ "$CFG_WEBSERVER" == "nginx" ]; then
  	if [ "$CFG_PHPMYADMIN" == "yes" ]; then
  		echo "Phpmyadmin is accessibile at  http://$CFG_HOSTNAME_FQDN:8081/phpmyadmin or http://IP_ADDRESS:8081/phpmyadmin";
	fi
  fi
fi


#ispconfig install on centos7
	if [ -f /etc/centos-release ]; then
		echo "Attention please, this is the very first version of the script for CentOS 7"
		echo -e "${red}Not yet implemented: courier, nginx support${NC}"
		echo -e "${green}Implemented: apache, mysql, bind, postfix, dovecot, roundcube webmail support${NC}"
		PreInstallCheck
		AskQuestions 
		InstallBasics 

		#remove postfix
		systemctl stop postfix
		systemctl disable postfix
		yum remove postfix -y 
		if [ $? == "0" ];then
			echo -e "Romove postfix:${green}Done${NC}"	
		else
			echo -e "Remove postfix:${red}failed${NC}"
		fi

		InstallSQLServer 
		InstallWebServer
		InstallFTP 
        	InstallWebStats 
		InstallJailkit 
		InstallISPConfig
		echo -e "${green}Well done! ISPConfig installed and configured correctly :D ${NC}"
		echo -e "Now you can connect to your ISPConfig installation at ${green}https://$CFG_HOSTNAME_FQDN:8080 or https://IP_ADDRESS:8080${NC}"
 		echo -e "Your ISPConfig admin's password is:${green}${CFG_ISPCONFIG_PWD}${NC}"
	else
		echo
		#echo -e "${red}Unsupported linux distribution.${NC}"
	fi

exit 0

