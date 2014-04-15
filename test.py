#_*_ coding: utf-8 _*_

import sh

check = sh.ifconfig
check = sh.grep("inet")
print check