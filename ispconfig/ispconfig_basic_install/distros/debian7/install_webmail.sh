#---------------------------------------------------------------------
# Function: InstallWebmail
#    Install the webmail client Roundcube
#---------------------------------------------------------------------
InstallWebmail() {
  CFG_ROUNDCUBE_DB="dbroundcube"
  CFG_ROUNDCUBE_USER="roundcube"

  echo -n "Installing webmail client roundcube... "
	  RANDPWD=`date +%N%s | md5sum`
	  echo "roundcube-core roundcube/dbconfig-install boolean true" | debconf-set-selections
	  echo "roundcube-core roundcube/database-type select mysql" | debconf-set-selections
	  echo "roundcube-core roundcube/mysql/admin-pass password $CFG_MYSQL_ROOT_PWD" | debconf-set-selections
	  echo "roundcube-core roundcube/db/dbname string $CFG_ROUNDCUBE_DB" | debconf-set-selections
	  echo "roundcube-core roundcube/mysql/app-pass password $CFG_ROUNDCUBE_PWD" | debconf-set-selections
	  echo "roundcube-core roundcube/app-password-confirm password $CFG_ROUNDCUBE_PWD" | debconf-set-selections
	  apt-get -y install roundcube roundcube-mysql git > /dev/null 2>&1
	  if [ $CFG_WEBSERVER == "apache" ]; then
	  	sed -i '1iAlias /webmail /var/lib/roundcube' /etc/roundcube/apache.conf
	  	sed -i "/Options +FollowSymLinks/a\\`echo -e '\n\r'`  DirectoryIndex index.php\\`echo -e '\n\r'`\\`echo -e '\n\r'`  <IfModule mod_php5.c>\\`echo -e '\n\r'`        AddType application/x-httpd-php .php\\`echo -e '\n\r'`\\`echo -e '\n\r'`        php_flag magic_quotes_gpc Off\\`echo -e '\n\r'`        php_flag track_vars On\\`echo -e '\n\r'`        php_flag register_globals Off\\`echo -e '\n\r'`        php_value include_path .:/usr/share/php\\`echo -e '\n\r'`  </IfModule>" /etc/roundcube/apache.conf
	  	sed -i "s/\$rcmail_config\['default_host'\] = '';/\$rcmail_config\['default_host'\] = 'localhost';/" /etc/roundcube/main.inc.php

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
	  service apache2 restart > /dev/null 2>&1
  else
	  service nginx restart > /dev/null 2>&1
  fi
  echo -e "${green}done! ${NC}\n"
}

