#---------------------------------------------------------------------
# Function: InstallISPConfig
#    Start the ISPConfig3 installation script
#---------------------------------------------------------------------
InstallISPConfig() {
  #CFG_MYSQL_ROOT_PWD=${CFG_MYSQL_ROOT_PWD//\\/}
  echo "Installing ISPConfig3... "
  cd $PWD
  tar -xvf ISPConfig-3-stable.tar.gz &>/dev/null
  cd ispconfig3_install/install/
  echo "Create INI file"
  [ -f autoinstall.ini ] && rm -f autoinstall.ini
  touch autoinstall.ini
  echo "[install]" > autoinstall.ini
  echo "language=en" >> autoinstall.ini
  echo "install_mode=standard" >> autoinstall.ini
  echo "hostname=$CFG_HOSTNAME_FQDN" >> autoinstall.ini
  echo "mysql_hostname=localhost" >> autoinstall.ini
  echo "mysql_root_user=root" >> autoinstall.ini
  echo "mysql_root_password=$CFG_MYSQL_ROOT_PWD" >> autoinstall.ini
  echo "mysql_database=dbispconfig" >> autoinstall.ini
  echo "mysql_charset=utf8" >> autoinstall.ini
  if [ $CFG_WEBSERVER == "apache" ]; then
	echo "http_server=apache" >> autoinstall.ini
  else
	echo "http_server=nginx" >> autoinstall.ini
  fi
  echo "ispconfig_port=8080" >> autoinstall.ini
  echo "ispconfig_use_ssl=y" >> autoinstall.ini
  echo
  echo "[ssl_cert]" >> autoinstall.ini
  echo "ssl_cert_country=EN" >> autoinstall.ini
  echo "ssl_cert_state=USA" >> autoinstall.ini
  echo "ssl_cert_locality=Texas" >> autoinstall.ini
  echo "ssl_cert_organisation=DBM" >> autoinstall.ini
  echo "ssl_cert_organisation_unit=IT" >> autoinstall.ini
  echo "ssl_cert_common_name=$CFG_HOSTNAME_FQDN" >> autoinstall.ini
  echo "ssl_cert_email_address=support@databasemart.com" >> autoinstall.ini
  echo
  echo "[expert]" >> autoinstall.ini
  echo "mysql_ispconfig_user=ispconfig" >> autoinstall.ini
  echo "mysql_ispconfig_password=$CFG_MYSQL_ROOT_PWD" >> autoinstall.ini
  echo "join_multiserver_setup=n" >> autoinstall.ini
  echo "mysql_master_hostname=master.example.com" >> autoinstall.ini
  echo "mysql_master_root_user=root" >> autoinstall.ini
  echo "mysql_master_root_password=ispconfig" >> autoinstall.ini
  echo "mysql_master_database=dbispconfig" >> autoinstall.ini
  echo "configure_mail=n" >> autoinstall.ini
  echo "configure_jailkit=$CFG_JKIT" >> autoinstall.ini
  echo "configure_ftp=y" >> autoinstall.ini
  echo "configure_dns=n" >> autoinstall.ini

  if [ $CFG_WEBSERVER == "apache" ]; then
  echo "configure_apache=y" >> autoinstall.ini
  else
  echo "configure_nginx=y" >> autoinstall.ini
  fi

  echo "configure_firewall=y" >> autoinstall.ini
  echo "install_ispconfig_web_interface=y" >> autoinstall.ini
  echo
  echo "[update]" >> autoinstall.ini
  echo "do_backup=yes" >> autoinstall.ini
  echo "mysql_root_password=$CFG_MYSQL_ROOT_PWD" >> autoinstall.ini
  #echo "mysql_root_password=$MYSQL_PASSWD" >> autoinstall.ini
  echo "mysql_master_hostname=master.example.com" >> autoinstall.ini
  echo "mysql_master_root_user=root" >> autoinstall.ini
  echo "mysql_master_root_password=ispconfig" >> autoinstall.ini
  echo "mysql_master_database=dbispconfig" >> autoinstall.ini
  echo "reconfigure_permissions_in_master_database=no" >> autoinstall.ini
  echo "reconfigure_services=yes" >> autoinstall.ini
  echo "ispconfig_port=8080" >> autoinstall.ini
  echo "create_new_ispconfig_ssl_cert=no" >> autoinstall.ini
  echo "reconfigure_crontab=yes" >> autoinstall.ini
  echo | php -q install.php --autoinstall=autoinstall.ini
  
  #set ispconfig login password
  update_sql="update sys_user set passwort=md5('${CFG_ISPCONFIG_PWD}') where username='admin'"
  mysql -uroot -p${CFG_MYSQL_ROOT_PWD} dbispconfig  -e"${update_sql}"
}
