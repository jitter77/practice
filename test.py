import sh

check = sh.ifconfig
check = sh.grep("inet")
print check