#---------------------------------------------------------------------
# Function: InstallWebmail
#    Install the webmail client Roundcube
#---------------------------------------------------------------------
InstallWebmail() {
  CFG_ROUNDCUBE_DB="dbroundcube"
  CFG_ROUNDCUBE_USER="roundcube"

  echo -n "Installing webmail client roundcube "
	  yum -y install roundcubemail > /dev/null 2>&1
	  mysql -u root -p$CFG_MYSQL_ROOT_PWD -e 'CREATE DATABASE '$CFG_ROUNDCUBE_DB';'
	  mysql -u root -p$CFG_MYSQL_ROOT_PWD -e "CREATE USER '$CFG_ROUNDCUBE_USER'@localhost IDENTIFIED BY '$CFG_ROUNDCUBE_PWD'"
	  mysql -u root -p$CFG_MYSQL_ROOT_PWD -e 'GRANT ALL PRIVILEGES on '$CFG_ROUNDCUBE_DB'.* to '$CFG_ROUNDCUBE_USER'@localhost'
	  mysql -u root -p$CFG_MYSQL_ROOT_PWD -e 'FLUSH PRIVILEGES;'
	  cat /etc/roundcubemail/config.inc.php.sample | grep -v db_dsnw > /etc/roundcubemail/config.inc.php
	  sed -i "/$config = array();/ a \$config[\\'db_dsnw\\'] = \\'mysql:\/\/$CFG_ROUNDCUBE_USER:$CFG_ROUNDCUBE_PWD@localhost\/$CFG_ROUNDCUBE_DB\\';" /etc/roundcubemail/config.inc.php
	  mysql -u $CFG_ROUNDCUBE_USER -p$CFG_ROUNDCUBE_PWD $CFG_ROUNDCUBE_DB < /usr/share/roundcubemail/SQL/mysql.initial.sql
	  if [ $CFG_WEBSERVER == "apache" ]; then
		echo "Alias /roundcubemail /usr/share/roundcubemail" > /etc/httpd/conf.d/roundcubemail.conf
		echo "Alias /webmail /usr/share/roundcubemail" >> /etc/httpd/conf.d/roundcubemail.conf
		echo "<Directory /usr/share/roundcubemail/>" >> /etc/httpd/conf.d/roundcubemail.conf
		echo "        Options none" >> /etc/httpd/conf.d/roundcubemail.conf
		echo "        AllowOverride Limit" >> /etc/httpd/conf.d/roundcubemail.conf
		echo "        Require all granted" >> /etc/httpd/conf.d/roundcubemail.conf
		echo "</Directory>" >> /etc/httpd/conf.d/roundcubemail.conf
		echo "<Directory /usr/share/roundcubemail/installer>" >> /etc/httpd/conf.d/roundcubemail.conf
		echo "        Options none" >> /etc/httpd/conf.d/roundcubemail.conf
		echo "        AllowOverride Limit" >> /etc/httpd/conf.d/roundcubemail.conf
		echo "        Require all granted" >> /etc/httpd/conf.d/roundcubemail.conf
		echo "</Directory>" >> /etc/httpd/conf.d/roundcubemail.conf
		echo "<Directory /usr/share/roundcubemail/bin/>" >> /etc/httpd/conf.d/roundcubemail.conf
		echo "    Order Allow,Deny" >> /etc/httpd/conf.d/roundcubemail.conf
		echo "    Deny from all" >> /etc/httpd/conf.d/roundcubemail.conf
		echo "</Directory>" >> /etc/httpd/conf.d/roundcubemail.conf
		echo "<Directory /usr/share/roundcubemail/plugins/enigma/home/>" >> /etc/httpd/conf.d/roundcubemail.conf
		echo "    Order Allow,Deny" >> /etc/httpd/conf.d/roundcubemail.conf
		echo "    Deny from all" >> /etc/httpd/conf.d/roundcubemail.conf
		echo "</Directory>" >> /etc/httpd/conf.d/roundcubemail.conf
	  else
		echo "  location /roundcube {" > /etc/nginx/roundcube.conf
		echo "          root /var/lib/;" >> /etc/nginx/roundcube.conf
		echo "           index index.php index.html index.htm;" >> /etc/nginx/roundcube.conf
		echo "           location ~ ^/roundcube/(.+\.php)\$ {" >> /etc/nginx/roundcube.conf
		echo "                   try_files \$uri =404;" >> /etc/nginx/roundcube.conf
		echo "                   root /var/lib/;" >> /etc/nginx/roundcube.conf
		echo "                   fastcgi_param   QUERY_STRING            \$query_string;" >> /etc/nginx/roundcube.conf
		echo "                   fastcgi_param   REQUEST_METHOD          \$request_method;" >> /etc/nginx/roundcube.conf
		echo "                   fastcgi_param   CONTENT_TYPE            \$content_type;" >> /etc/nginx/roundcube.conf
		echo "                   fastcgi_param   CONTENT_LENGTH          \$content_length;" >> /etc/nginx/roundcube.conf
		echo "                   fastcgi_param   SCRIPT_FILENAME         \$request_filename;" >> /etc/nginx/roundcube.conf
		echo "                   fastcgi_param   SCRIPT_NAME             \$fastcgi_script_name;" >> /etc/nginx/roundcube.conf
		echo "                   fastcgi_param   REQUEST_URI             \$request_uri;" >> /etc/nginx/roundcube.conf
		echo "                   fastcgi_param   DOCUMENT_URI            \$document_uri;" >> /etc/nginx/roundcube.conf
		echo "                   fastcgi_param   DOCUMENT_ROOT           \$document_root;" >> /etc/nginx/roundcube.conf
		echo "                   fastcgi_param   SERVER_PROTOCOL         \$server_protocol;" >> /etc/nginx/roundcube.conf
		echo "                   fastcgi_param   GATEWAY_INTERFACE       CGI/1.1;" >> /etc/nginx/roundcube.conf
		echo "                   fastcgi_param   SERVER_SOFTWARE         nginx/\$nginx_version;" >> /etc/nginx/roundcube.conf
		echo "                   fastcgi_param   REMOTE_ADDR             \$remote_addr;" >> /etc/nginx/roundcube.conf
		echo "                   fastcgi_param   REMOTE_PORT             \$remote_port;" >> /etc/nginx/roundcube.conf
		echo "                   fastcgi_param   SERVER_ADDR             \$server_addr;" >> /etc/nginx/roundcube.conf
		echo "                   fastcgi_param   SERVER_PORT             \$server_port;" >> /etc/nginx/roundcube.conf
		echo "                   fastcgi_param   SERVER_NAME             \$server_name;" >> /etc/nginx/roundcube.conf
		echo "                   fastcgi_param   HTTPS                   \$https;" >> /etc/nginx/roundcube.conf
		echo "                   # PHP only, required if PHP was built with --enable-force-cgi-redirect" >> /etc/nginx/roundcube.conf
		echo "                   fastcgi_param   REDIRECT_STATUS         200;" >> /etc/nginx/roundcube.conf
		echo "                   # To access SquirrelMail, the default user (like www-data on Debian/Ubuntu) mu\$" >> /etc/nginx/roundcube.conf
		echo "                   #fastcgi_pass 127.0.0.1:9000;" >> /etc/nginx/roundcube.conf
		echo "                   fastcgi_pass unix:/var/run/php5-fpm.sock;" >> /etc/nginx/roundcube.conf
		echo "                   fastcgi_index index.php;" >> /etc/nginx/roundcube.conf
		echo "                   fastcgi_param SCRIPT_FILENAME \$document_root\$fastcgi_script_name;" >> /etc/nginx/roundcube.conf
		echo "                   fastcgi_buffer_size 128k;" >> /etc/nginx/roundcube.conf
		echo "                   fastcgi_buffers 256 4k;" >> /etc/nginx/roundcube.conf
		echo "                   fastcgi_busy_buffers_size 256k;" >> /etc/nginx/roundcube.conf
		echo "                   fastcgi_temp_file_write_size 256k;" >> /etc/nginx/roundcube.conf
		echo "           }" >> /etc/nginx/roundcube.conf
		echo "           location ~* ^/roundcube/(.+\.(jpg|jpeg|gif|css|png|js|ico|html|xml|txt))\$ {" >> /etc/nginx/roundcube.conf
		echo "                   root /var/lib/;" >> /etc/nginx/roundcube.conf
		echo "           }" >> /etc/nginx/roundcube.conf
		echo "           location ~* /.svn/ {" >> /etc/nginx/roundcube.conf
		echo "                   deny all;" >> /etc/nginx/roundcube.conf
		echo "           }" >> /etc/nginx/roundcube.conf
		echo "           location ~* /README|INSTALL|LICENSE|SQL|bin|CHANGELOG\$ {" >> /etc/nginx/roundcube.conf
		echo "                   deny all;" >> /etc/nginx/roundcube.conf
		echo "           }" >> /etc/nginx/roundcube.conf
		echo "          }" >> /etc/nginx/roundcube.conf
		sed -i "s/server_name localhost;/server_name localhost; include \/etc\/nginx\/roundcube.conf;/" /etc/nginx/sites-enabled/default
	  fi
  
if [ $CFG_WEBSERVER == "apache" ]; then
	  systemctl restart httpd.service > /dev/null 2>&1
  else
	  systemctl restart nginx > /dev/null 2>&1
  fi
  echo -e "${green}done! ${NC}\n"
}

