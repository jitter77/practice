#!/bin/sh

################################################
# Tool to program a polytouchdemo on Karo TX53 #
# Please send feedback to:                     #
# dominik.peuker@glyn.de                       #
# Dominik Peuker June 2015                     #
# Glyn Gmbh & Co. KG                           #
#                                              #
#History                                       #
#----------------------------------------------#
#0.1 - 19.06.2015 - Initial Version            #
################################################


clear
echo "Program Polytouchdemo to TX53(8030)"
echo "-----------------------------------"
echo
#Presetting
IPH=192.168.15.176                         #Host
IPT=192.168.15.205                         #Target
uboot=u-boot-tx6u-80x0.bin                 #Bootloader
image=setenv_poly_tx6.img                  #Environment
dtb=imx6dl-tx6u-80xx.dtb                   #Device Tree
kernel=uImage_tx6                          #Linux Kernel
rootfs=mucross-2.0-gpe-demo-tx6.ubi        #GPE-Demo
port=/dev/ttyUSB0                          #serial port for console
clear3=\x10
echo
#preparation
echo "Please check:"
echo "tftp - server running?"
echo "serial cable connected?"
echo "ethernet connected?"
echo "module TX53 (TX53-8030) inserted?"
echo "power supply connected?"
echo "continue (y/n)"
read continue
if [ "$continue" != y ]
 then
    echo "exiting now!"
    exit 0
 else
    clear
fi
#Keep or set IP adresses / serial port?
echo "IP adresses currently set to:"
echo "Host: "${IPH}
echo "Target: "${IPT}
echo "Serial port is currently set to "${port}
echo
echo "Keep these settings (y) or enter new adresses (n)?"
read settings
if [ "$settings" != y ]
	then
		#Host
		echo "Please enter IP of your host (serverip):"
		read IPH
		echo
		#Target
		echo "Please enter IP of your target (ipaddr):"
		read IPT
		echo
		#serial port
		echo "Please enter your serial like this: /dev/ttyS0:"
		read port
		echo
		#correct?
		echo "Host:"${IPH}
		echo "Target:"${IPT}
		echo "Port:"${port}
		#wait and clear screen
		sleep 4
		clear
	else
		#clear screen
		clear
fi

echo "Connect Board to power and hit STRG+C to stop bootprocess"
echo 'fconfig' > ${port}
echo '\010\010\010\010 false' > ${port}
echo '\010\010\010\010\010 true' > ${port}
echo '\010\010\010\010\010\010\010\010\010\010\010\010\010\010' ${IPH} > ${port}

#echo > $port
sleep 2
#echo '115200' > $port
#echo '\010\010\010\010 true' > $port
#echo > $port
#echo '9000' > $port
#echo '\010\010\010\010 false' > $port
#echo '\010\010\010\010 false' > $port
#echo '\010\010\010\010 false' > $port
#echo 'y' > $port
#echo 'reset' > $port
#echo -e '\x3'> $port
