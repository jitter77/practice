#!/bin/sh
clear
echo "Program Polytouchdemo to TX28"
echo
echo "Please enter IP of your host:"
read IPH
echo
echo "Please enter IP of your target:"
read IPT
echo
echo "Host:"$IPH
echo $IPT
echo
sleep 3
echo " 1/20 - Clean Partitions"
echo 'nand erase.part linux' > /dev/ttyUSB0
sleep 3
echo 'nand erase.part rootfs' > /dev/ttyUSB0
sleep 3
echo " 2/20 - Set IP adresses"
echo 'setenv serverip 192.168.15.168' > /dev/ttyUSB0
echo 'setenv ipaddr 192.168.15.205' > /dev/ttyUSB0
echo " 3/20 - Change autostart / autoload"
echo 'setenv autoload no' > /dev/ttyUSB0
echo 'setenv autostart no' > /dev/ttyUSB0
echo 'saveenv' > /dev/ttyUSB0
echo " 4/20 - Update Bootloader"
sleep 5
echo 'tftp ${loadaddr} u-boot-tx28-40x1.sb' > /dev/ttyUSB0 
echo " 5/20 - Transfering Bootloader"
sleep 10
echo " 6/20 - Installing Bootloader"
sleep 5
echo 'romupdate ${fileaddr}' > /dev/ttyUSB0
sleep 5
echo " 7/20 - Reset"
echo 'reset' > /dev/ttyUSB0
sleep 5
echo " 8/20 - Set default environment"
echo 'env default -f -a' > /dev/ttyUSB0
echo " 9/20 - Set IP adresses"
sleep 5
echo 'setenv serverip 192.168.15.168' > /dev/ttyUSB0
echo 'setenv ipaddr 192.168.15.205' > /dev/ttyUSB0
echo "10/20 - Transfer Environment"
echo 'tftp ${loadaddr} setenv.img' > /dev/ttyUSB0
sleep 8
echo 'source ${fileaddr}' > /dev/ttyUSB0
sleep 5
echo "11/20 - Transfering device tree"
echo 'tftp ${loadaddr} imx28-tx28.dtb' > /dev/ttyUSB0
sleep 8
echo 'nand erase.part dtb' > /dev/ttyUSB0
sleep 5
echo "12/20 - Save Device Tree"
echo 'nand write.jffs2 ${fileaddr} dtb ${filesize}' > /dev/ttyUSB0
sleep 5
echo 'saveenv' > /dev/ttyUSB0
echo 'reset' > /dev/ttyUSB0
sleep 5
echo > /dev/ttyUSB0
echo "13/20 - Transfering Linux Kernel"
echo 'tftp ${loadaddr} uImage-tx28-m09-raw' > /dev/ttyUSB0
sleep 15
echo 'nand erase.part linux' > /dev/ttyUSB0
sleep 5
echo "14/20 - Save Linux Kernel"
echo 'nand write.jffs2 ${fileaddr} linux ${filesize}' > /dev/ttyUSB0
sleep 5
echo "15/20 - Transfering Filesystem"
echo 'tftp ${loadaddr} touchdemo-m09-flip.ubi' > /dev/ttyUSB0
sleep 20
echo 'nand erase.part rootfs' > /dev/ttyUSB0
sleep 3
echo "16/20 - Save Filesystem"
echo 'nand write.trimffs ${fileaddr} rootfs ${filesize}' > /dev/ttyUSB0
sleep 5
echo "17/20 - Reset and Reboot"
echo 'reset' > /dev/ttyUSB0
sleep 3
echo > /dev/ttyUSB0
echo > /dev/ttyUSB0
echo "18/20 - Set backlight to full brightness"
sleep 4
echo 'fdt set /backlight default-brightness-level <0x01>'  > /dev/ttyUSB0
sleep 4
echo nand erase.part dtb > /dev/ttyUSB0
sleep 4
echo "19/20 - Save environment"
echo 'nand write.jffs2 ${fdtaddr} dtb' > /dev/ttyUSB0
sleep 4
echo "20/20 - Done!"
