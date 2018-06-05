#---------------------------------------------------------------------
# Function: InstallISPConfig
#    Start the ISPConfig3 installation script
#---------------------------------------------------------------------
InstallISPConfig() {
  echo "Installing ISPConfig3... "
  cd $pwd
  tar xfz ISPConfig-3-stable.tar.gz &>/dev/null
  cd ispconfig3_install/install/
  if [ $CFG_ISPC == "standard" ]; then
  	echo "Create INI file"
	touch autoinstall.ini
	echo "[install]" > autoinstall.ini
	echo "language=en" >> autoinstall.ini
	echo "install_mode=$CFG_ISPC" >> autoinstall.ini
	echo "hostname=$CFG_HOSTNAME_FQDN" >> autoinstall.ini
	echo "mysql_hostname=localhost" >> autoinstall.ini
	echo "mysql_root_user=root" >> autoinstall.ini
	echo "mysql_root_password=$CFG_MYSQL_ROOT_PWD" >> autoinstall.ini
	echo "mysql_database=dbispconfig" >> autoinstall.ini
	echo "mysql_port=3306" >> autoinstall.ini
	echo "mysql_charset=utf8" >> autoinstall.ini
	
	if [ $CFG_WEBSERVER == "apache" ]; then
		echo "http_server=apache" >> autoinstall.ini
	elif [ $CFG_WEBSERVER == "nginx" ]; then
		echo "http_server=nginx" >> autoinstall.ini
	else
    	echo "http_server=" >> autoinstall.ini
  	fi

	echo "ispconfig_port=8080" >> autoinstall.ini
	echo "ispconfig_use_ssl=y" >> autoinstall.ini
	echo
	echo "[ssl_cert]" >> autoinstall.ini
	echo "ssl_cert_country=$SSL_COUNTRY" >> autoinstall.ini
    	echo "ssl_cert_state=$SSL_STATE" >> autoinstall.ini
	echo "ssl_cert_locality=$SSL_LOCALITY" >> autoinstall.ini
	echo "ssl_cert_organisation=$SSL_ORGANIZATION" >> autoinstall.ini
	echo "ssl_cert_organisation_unit=$SSL_ORGUNIT" >> autoinstall.ini
	echo "ssl_cert_common_name=$CFG_HOSTNAME_FQDN" >> autoinstall.ini
	echo "ssl_cert_email_address=support@databasemart.com" >> autoinstall.ini
	echo
	echo "[expert]" >> autoinstall.ini
	echo "mysql_ispconfig_user=ispconfig" >> autoinstall.ini
	echo "mysql_ispconfig_password=$CFG_MYSQL_ROOT_PWD" >> autoinstall.ini
	echo "join_multiserver_setup=n" >> autoinstall.ini
    	echo "mysql_master_hostname=$CFG_HOSTNAME_FQDN" >> autoinstall.ini
	echo "mysql_master_root_user=root" >> autoinstall.ini
	echo "mysql_master_root_password=$CFG_MYSQL_ROOT_PWD" >> autoinstall.ini
	echo "mysql_master_database=dbispconfig" >> autoinstall.ini
	echo "configure_mail=n" >> autoinstall.ini
      	echo "configure_jailkit=y" >> autoinstall.ini
    	echo "configure_ftp=y" >> autoinstall.ini
	echo "configure_dns=n"> autoinstall.ini
	echo "configure_firewall=y" >> autoinstall.ini
	echo "install_ispconfig_web_interface=$CFG_SETUP_MASTER" >> autoinstall.ini
	echo
	echo "[update]" >> autoinstall.ini
	echo "do_backup=yes" >> autoinstall.ini
	echo "mysql_root_password=$CFG_MYSQL_ROOT_PWD" >> autoinstall.ini
    	echo "mysql_master_hostname=$CFG_HOSTNAME_FQDN" >> autoinstall.ini
	echo "mysql_master_root_user=root" >> autoinstall.ini
    	echo "mysql_master_root_password=$CFG_MYSQL_ROOT_PWD" >> autoinstall.ini
	echo "mysql_master_database=dbispconfig" >> autoinstall.ini
	echo "reconfigure_permissions_in_master_database=no" >> autoinstall.ini
	echo "reconfigure_services=yes" >> autoinstall.ini
    	echo "ispconfig_port=8080" >> autoinstall.ini
	echo "create_new_ispconfig_ssl_cert=no" >> autoinstall.ini
    	echo "reconfigure_crontab=yes" >> autoinstall.ini
    echo | php -q install.php --autoinstall=autoinstall.ini
  else
    php -q install.php
  fi

  #set ispconfig login password
  update_sql="update sys_user set passwort=md5('${CFG_ISPCONFIG_PWD}') where username='admin'"
  mysql -uroot -p${CFG_MYSQL_ROOT_PWD} dbispconfig  -e"${update_sql}"

    if [ $CFG_WEBSERVER == "nginx" ]; then
        /etc/init.d/nginx restart
     else
        /etc/init.d/apache2 restart
     fi

}
