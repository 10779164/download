#!/bin/bash

PWD=$(pwd)
WT_BACKTITLE="ISPConfig 3 System update"
CFG_HOSTNAME_FQDN=`hostname`

# Bash Colour
red='\033[0;31m'
green='\033[0;32m'
NC='\033[0m' # No Color

if [ ! -d "ispconfig3_install" ];then
tar -xvf ISPConfig-3-stable.tar.gz &>/dev/null
fi

#[ -f /bin/whiptail ] && echo -e "whiptail found: ${green}OK${NC}\n"  || yum -y install newt


source $PWD/functions/check_linux.sh
echo "Checking your system, please wait..."
CheckLinux

#ssl
source $PWD/functions/ssl.sh
Openssl

source $PWD/distros/$DISTRO/askquestions_update.sh
AskQuestions_update

#verification database passwd
mysql -uroot -p${CFG_MYSQL_ROOT_PWD} -e quit &>/dev/null
if [ "$?" == "0" ];then
	echo -e "Database verification: ${green}Success${NC}"
else
	echo -e "Database verification: ${red}Password error, Please try again...${NC}"
	sleep 2
	echo -e "${red}Exit script...${NC}"
	exit
fi


if [ "$CFG_SERVICE" == "MAIL" ];then
  echo "Start updata webmail for ispconfig..."
  source $PWD/distros/$DISTRO/install_postfix.sh
  source $PWD/distros/$DISTRO/install_webmail.sh
  source $PWD/distros/$DISTRO/install_mta.sh

  cd $PWD/ispconfig3_install/install
  [ -f "autoinstall.ini" ] && rm -f autoinstall.ini

  echo "Start update web mail..."
  [ -f "autoinstall.ini" ] && rm -f autoinstall.ini
  touch autoinstall.ini
  echo "[update]" >> autoinstall.ini
  echo "svc_detect_change_db_server=no">> autoinstall.ini  
  echo "svc_detect_change_mail_server=yes" >> autoinstall.ini
  echo "do_backup=yes" >> autoinstall.ini
  echo "reconfigure_permissions_in_master_database=no" >> autoinstall.ini
  echo "svc_detect_change_firewall_server=no" >> autoinstall.ini
  echo "reconfigure_services=yes" >> autoinstall.ini
  echo "ispconfig_port=8080" >> autoinstall.ini
  echo "create_new_ispconfig_ssl_cert=no" >> autoinstall.ini
  echo "reconfigure_crontab=yes" >> autoinstall.ini

  InstallPostfix
  InstallWebmail
  InstallMTA

  php -q update.php --autoinstall=autoinstall.ini
  if [ $? == "0" ];then
  	echo -e "${green}ispconfig update successfully...${NC}"
  	echo -e "Now you can connect to your roundcube webmail at ${green}http://$CFG_HOSTNAME_FQDN/webmail or http://IP_ADDRESS/webmail${NC}"
  else
  	echo -e "${red}ispconfig update failed...${NC}"
  fi

elif [ "$CFG_SERVICE" == "DNS" ];then
  echo "Start updata dns for ispconfig..."
  source $PWD/distros/$DISTRO/install_bind.sh

  cd $PWD/ispconfig3_install/install
  [ -f "autoinstall.ini" ] && rm -f autoinstall.ini
  echo "[update]" >> autoinstall.ini
  echo "svc_detect_change_db_server=no">> autoinstall.ini
  echo "svc_detect_change_dns_server=yes" >> autoinstall.ini
  echo "do_backup=yes" >> autoinstall.ini
  echo "reconfigure_permissions_in_master_database=no" >> autoinstall.ini
  echo "svc_detect_change_firewall_server=no" >> autoinstall.ini
  echo "reconfigure_services=yes" >> autoinstall.ini
  echo "ispconfig_port=8080" >> autoinstall.ini
  echo "create_new_ispconfig_ssl_cert=no" >> autoinstall.ini
  echo "reconfigure_crontab=yes" >> autoinstall.ini
 
 
  InstallBind

  php -q update.php --autoinstall=autoinstall.ini
  if [ $? == "0" ];then
  	echo -e "${green}ispconfig update successfully...${NC}"
  else
  	echo -e "${red}ispconfig update failed...${NC}"
  fi

else
  echo "Start updata dns and mail for ispconfig..."
  source $PWD/distros/$DISTRO/install_postfix.sh
  source $PWD/distros/$DISTRO/install_webmail.sh
  source $PWD/distros/$DISTRO/install_mta.sh
  source $PWD/distros/$DISTRO/install_bind.sh

  cd $PWD/ispconfig3_install/install
  [ -f "autoinstall.ini" ] && rm -f autoinstall.ini
  echo "[update]" >> autoinstall.ini
  echo "svc_detect_change_db_server=no">> autoinstall.ini
  echo "svc_detect_change_dns_server=yes" >> autoinstall.ini
  echo "svc_detect_change_mail_server=yes" >> autoinstall.ini
  echo "do_backup=yes" >> autoinstall.ini
  echo "reconfigure_permissions_in_master_database=no" >> autoinstall.ini
  echo "svc_detect_change_firewall_server=no" >> autoinstall.ini
  echo "reconfigure_services=yes" >> autoinstall.ini
  echo "ispconfig_port=8080" >> autoinstall.ini
  echo "create_new_ispconfig_ssl_cert=no" >> autoinstall.ini
  echo "reconfigure_crontab=yes" >> autoinstall.ini

  InstallPostfix
  InstallWebmail
  InstallMTA
  InstallBind
  
  php -q update.php --autoinstall=autoinstall.ini
  if [ $? == "0" ];then
  	echo -e "${green}ispconfig update successfully...${NC}"
	echo -e "Now you can connect to your roundcube webmail at ${green}http://$CFG_HOSTNAME_FQDN/webmail or http://IP_ADDRESS/webmail${NC}"
  else
  	echo -e "${red}ispconfig update failed...${NC}"
  fi

fi









