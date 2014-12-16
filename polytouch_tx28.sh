#!/bin/sh

################################################
# Tool to program a polytouchdemo on Karo TX28 #
# Please send feedback to:                     #
# dominik.peuker@glyn.de                       #
# Dominik Peuker November 2014                 # 
# Glyn Gmbh & Co. KG                           #
################################################

clear
echo "Program Polytouchdemo to TX28"
echo "-----------------------------"
echo
#Presetting
IPH=192.168.15.168
IPT=192.168.15.205
port=/dev/ttyUSB0
echo
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
#Mainfunction
#cleanup
echo " 1/20 - Clean Partitions"
#delet kernel
echo 'nand erase.part linux' > ${port}
sleep 3
#delete rootfs
echo 'nand erase.part rootfs' > ${port}
sleep 3
echo " 2/20 - Set IP adresses"
echo 'setenv serverip '${IPH} > ${port}
echo 'setenv ipaddr '${IPT} > ${port}
echo " 3/20 - Change autostart / autoload"
echo 'setenv autoload no' > ${port}
echo 'setenv autostart no' > ${port}
echo 'saveenv' > ${port}
echo " 4/20 - Update Bootloader"
sleep 5
echo 'tftp ${loadaddr} u-boot-tx28-40x1.sb' > ${port}
echo " 5/20 - Transfering Bootloader"
sleep 10
echo " 6/20 - Installing Bootloader"
sleep 5
echo 'romupdate ${fileaddr}' > ${port}
sleep 5
echo " 7/20 - Reset"
echo 'reset' > ${port}
sleep 5
echo " 8/20 - Set default environment"
echo 'env default -f -a' > ${port}
echo " 9/20 - Set IP adresses"
sleep 5
echo 'setenv serverip '${IPH} > ${port}
echo 'setenv ipaddr '${IPT} > ${port}
echo "10/20 - Transfer Environment"
#copy and source predefinded environment
echo 'tftp ${loadaddr} setenv.img' > ${port}
sleep 8
echo 'source ${fileaddr}' > ${port}
sleep 5
echo "11/20 - Transfering device tree"
echo 'tftp ${loadaddr} imx28-tx28.dtb' > ${port}
sleep 8
echo 'nand erase.part dtb' > ${port}
sleep 5
echo "12/20 - Save device tree"
echo 'nand write.jffs2 ${fileaddr} dtb ${filesize}' > ${port}
sleep 5
echo 'saveenv' > ${port}
echo 'reset' > ${port}
sleep 5
echo > ${port}
#copy and install kernel
echo "13/20 - Transfering Linux Kernel"
echo 'tftp ${loadaddr} uImage-tx28-m09-raw' > ${port}
sleep 15
echo 'nand erase.part linux' > ${port}
sleep 5
echo "14/20 - Save Linux Kernel"
echo 'nand write.jffs2 ${fileaddr} linux ${filesize}' > ${port}
sleep 5
#copy and install filesystem
echo "15/20 - Transfering Filesystem"
echo 'tftp ${loadaddr} touchdemo-m09-flip.ubi' > ${port}
sleep 25
echo 'nand erase.part rootfs' > ${port}
sleep 5
echo "16/20 - Save Filesystem"
echo 'nand write.trimffs ${fileaddr} rootfs ${filesize}' > ${port}
sleep 15
echo "17/20 - Reset and Reboot"
echo 'reset' > ${port}
sleep 3
echo > ${port}
echo > ${port}
#backlight is only 50% so far, set it to 100%
echo "18/20 - Set backlight to full brightness"
sleep 6
echo 'fdt set /backlight default-brightness-level <0x01>'  > ${port}
sleep 3
echo > ${port}
sleep 3
echo 'nand erase.part dtb' > ${port}
sleep 3
echo "19/20 - Save environment"
sleep 3
echo > ${port}
echo 'nand write.jffs2 ${fdtaddr} dtb' > ${port}
sleep 3
echo "20/20 - Done!"
#ready for start
