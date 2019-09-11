#!/bin/bash

# Bash Colour
red='\033[0;31m'
green='\033[0;32m'
NC='\033[0m'

HOME="/usr/local/src"

#Check php
php -v &>/dev/null
if [ $? -eq 0 ];then
    local_php_version=$(php -v | sed -n 1p | awk '{print $2}')
else
    local_php_version="None"
fi

[ -f /bin/whiptail ] && echo -e "whiptail found: ${green}OK${NC}\n"  || yum -y install newt &>/dev/null

CFG_PHPVERSION=$(whiptail --title "php version" --backtitle "Current system php version: ${local_php_version}" --nocancel --radiolist "Select php version" 10 50 4 "php-7.0.32" "" ON "php-5.6.38" "" OFF "php-7.1.23" "" OFF "php-7.2.11" ""  OFF 3>&1 1>&2 2>&3)
CFG_PORT=$(whiptail --title "php-fpm listen port"   --inputbox "please verify the php-fpm listening port(eg: 9001) " --nocancel 10 50 3>&1 1>&2 2>&3)

php_version=`echo $CFG_PHPVERSION | awk -F'-' '{print $2}'`

#Install php
echo ""
echo  "Start install php-${php_version}..."
yum install wget -y &>/dev/null
cd $HOME && wget http://php.net/distributions/php-${php_version}.tar.gz &> /dev/null && echo -e "${green}OK${NC}"
echo ""

echo "Install php module..."
yum -y install epel-release 1> /dev/null && \
yum -y install gcc libxml2-devel openssl-devel curl-devel libjpeg-devel libpng-devel freetype-devel libmcrypt-devel 1> /dev/null && \
echo -e "${green}OK${NC}"
echo ""

echo "Install php..."
tar -xf php-${php_version}.tar.gz
cd php-${php_version}

#id nginx && web_user="nginx" || id apache && web_user="apache" || web_user="nobody"
#web_user
id nginx 2>/dev/null || id apache 2>/dev/null
if [ $? -eq 0 ];then
    id nginx 2>/dev/null && web_user="nginx" || web_user="apache"
else
    web_user="nobody"
fi

#config
./configure \
--prefix=/usr/local/php-${php_version} \
--with-config-file-path=/usr/local/php-${php_version}/etc \
--enable-fpm \
--with-pdo_sqlite \
--with-iconv \
--enable-ftp \
--with-sqlite3 \
--enable-mbstring \
--enable-sockets \
--enable-zip \
--enable-soap \
--enable-bcmath \
--enable-sockets \
--with-gettext \
--with-openssl \
--with-zlib \
--with-curl \
--with-gd \
--with-jpeg-dir \
--with-png-dir \
--with-freetype-dir \
--with-mcrypt=/usr/local \
--with-mhash \
--with-libdir=/lib \
--enable-opcache \
--with-mysqli=mysqlnd \
--with-pdo-mysql=mysqlnd \
--without-pear \
--disable-fileinfo \
--with-fpm-user=${web_user} \
--with-fpm-group=${web_user} &>/dev/null

#install
make &>dev/null && make install & >/dev/null && echo -e "${green}OK${NC}"
echo ""
cp php.ini-production /usr/local/php-${php_version}/etc/php.ini


cd /usr/local/php-${php_version}/
cp etc/php-fpm.conf.default etc/php-fpm.conf
cp etc/php-fpm.d/www.conf.default etc/php-fpm.d/www.conf
sed -i "s/listen = 127.0.0.1:9000/listen = 127.0.0.1:${CFG_PORT}/g" etc/php-fpm.d/www.conf
mv sbin/php-fpm sbin/php-fpm${php_version}
ln -s /usr/local/php-${php_version}/sbin/php-fpm${php_version} /usr/sbin/

echo "Create system service..."
cat > /usr/lib/systemd/system/php-fpm${php_version}.service <<EOF
[Unit]
Description=php
After=network.target remote-fs.target nss-lookup.target
[Service]
Type=forking
PIDFile=/usr/local/php-${php_version}/var/run/php-fpm.pid
ExecStart=/usr/local/php-${php_version}/sbin/php-fpm --nodaemonize --fpm-config /usr/local/php-${php_version}/etc/php-fpm.conf
ExecReload=/bin/kill -USR2 $MAINPID
PrivateTmp=true

[Install]
WantedBy=multi-user.target
EOF

echo -e "${green}OK${NC}"
echo ""

#Check config
echo "Check config..."
php-fpm${php_version} -t 1>/dev/null
if [ $? -eq 0 ];then
	systemctl start php-fpm${php_version}.service
	systemctl enable php-fpm${php_version}.service
	echo -e "${green}php-${php_version} installed successfully!!${NC}" 
	echo -e "${green}php-fpm listening port: ${CFG_PORT}${NC}"
else
	echo -e "${red}php-fpm test failed. Please check your config file.${NC}"
	exit
fi

