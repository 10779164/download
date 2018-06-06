#---------------------------------------------------------------------
# Function: InstallWebStats
#    Install and configure web stats
#---------------------------------------------------------------------
InstallWebStats() {
  echo -n "Installing stats... ";
  yum -y install awstats webalizer perl-DateTime-Format-HTTP perl-DateTime-Format-Builder > /dev/null 2>&1
  echo -e "${green}done! ${NC}\n"
}

