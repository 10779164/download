#---------------------------------------------------------------------
# Function: InstallSQLServer
#    Install and configure SQL Server
#---------------------------------------------------------------------
InstallSQLServer() {
  #if [ "$CFG_SQLSERVER" == "MySQL" ]; then
    echo -n "Installing MySQL... "
    apt-get -yqq install mariadb-client mariadb-server expect
    sed -i 's/bind-address		= 127.0.0.1/#bind-address		= 127.0.0.1/' /etc/mysql/mariadb.conf.d/50-server.cnf
    systemctl enable mariadb.service > /dev/null 2>&1
    systemctl start mariadb.service > /dev/null 2>&1

    ##mysql_secure_installation
    SECURE_MYSQL=$(expect -c "
    set timeout 3
    spawn mysql_secure_installation
    expect \"Enter current password for root (enter for none):\"
    send \"\r\"
    expect \"set root password?\"
    send \"y\r\"
    expect \"New password:\"
    send \"$CFG_MYSQL_ROOT_PWD\r\"
    expect \"Re-enter new password:\"
    send \"$CFG_MYSQL_ROOT_PWD\r\"
    expect \"Remove anonymous users?\"
    send \"y\r\"
    expect \"Disallow root login remotely?\"
    send \"y\r\"
    expect \"Remove test database and access to it?\"
    send \"y\r\"
    expect \"Reload privilege tables now?\"
    send \"y\r\"
    expect eof
    ")
    echo "${SECURE_MYSQL}"
    echo "update mysql.user set plugin = 'mysql_native_password' where user='root';" | mysql -uroot -p${CFG_MYSQL_ROOT_PWD}
    sed -i 's/bind-address		= 127.0.0.1/#bind-address		= 127.0.0.1/g' /etc/mysql/mariadb.conf.d/50-server.cnf
    sed -i 's/password = /password = '${CFG_MYSQL_ROOT_PWD}'/g' /etc/mysql/debian.cnf
    sed -i "/\[mysqld\]/a\ sql-mode='NO_ENGINE_SUBSTITUTION'" /etc/mysql/mariadb.conf.d/50-server.cnf

    systemctl restart mariadb.service > /dev/null 2>&1
    echo -e "[${green}DONE${NC}]\n"
}
