#_*_ coding: utf-8 _*_
__version__ = '0.1'
import sh

check = sh.ifconfig
check = sh.grep("inet")
print check