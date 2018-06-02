AskQuestions_update() {

	CFG_SERVICE=$(whiptail --title "update ispconfig" --backtitle "$WT_BACKTITLE" --nocancel --radiolist "Select you want update service" 10 50 3 "MAIL" "" ON "DNS" "" OFF "MAIL and DNS" "" OFF 3>&1 1>&2 2>&3)

	while [ "x$CFG_MYSQL_ROOT_PWD" == "x" ]
          do
                CFG_MYSQL_ROOT_PWD=$(whiptail --title "MySQL root password" --backtitle "$WT_BACKTITLE" --inputbox "Please enter the root password for the database~" --nocancel 10 50 3>&1 1>&2 2>&3)
          done

	CFG_WEBSERVER=$(whiptail --title "update ispconfig" --backtitle "$WT_BACKTITLE" --nocancel --radiolist "Confirm webserver~" 10 50 2 "apache" "" ON "nginx" "" OFF  3>&1 1>&2 2>&3)

	if [ "$CFG_SERVICE" == "MAIL" ] || [ "$CFG_SERVICE" == "MAIL and DNS" ];then
        	CFG_ROUNDCUBE_PWD=$(whiptail --title "ISPConfig roundcube database password" --backtitle "$WT_BACKTITLE" --inputbox "Please specify database dbroundcube's password" --nocancel 10 50 3>&1 1>&2 2>&3)
	fi

}


