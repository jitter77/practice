#!/bin/sh

################################################
# Tool to program a Console - demo on Karo TX48#
# Please send feedback to:                     #
# dominik.peuker@glyn.de                       #
# Dominik Peuker December 2014                 # 
# Glyn Gmbh & Co. KG                           #
#                                              #
#History                                       #
#----------------------------------------------#
#0.1 - 16.12.2014 - Initial Version            #
#1.0 - 13.01.2015 - Override IP - settings in  #
#                   predefined environment     #
#1.1 - 13.01.2015 - Change display settings    #
################################################

clear
echo "Program Qt-demo to TX48"
echo "-----------------------"
echo
#Presetting
IPH=192.168.15.173 #Host
IPT=192.168.15.205 #Target
port=/dev/ttyUSB0
#TX48 needs 2 parts of the bootloader
uboot1=MLO-tx48
uboot2=u-boot-tx48.img
image=setenv_poly_tx48.img
dtb=am335x-tx48.dtb
kernel=uImage_tx48
rootfs=mucross-2.0-gpe-demo-tx48.ubi
splash=glynsplash.bmp
echo
#preparation
echo "Please check:"
echo "tftp - server running?"
echo "serial cable connected?"
echo "ethernet connected?"
echo "module TX48 (TX48-7020) inserted?"
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
echo " 1/22 - Clean Partitions"
#delete kernel
echo 'nand erase.part linux' > ${port}
sleep 3
#delete rootfs
echo 'nand erase.part rootfs' > ${port}
sleep 3
echo " 2/22 - Set IP adresses"
echo 'setenv serverip '${IPH} > ${port}
echo 'setenv ipaddr '${IPT} > ${port}
echo " 3/22 - Change autostart / autoload"
echo 'setenv autoload no' > ${port}
echo 'setenv autostart no' > ${port}
echo 'saveenv' > ${port}
echo " 4/22 - Update Bootloader - Transfer Bootloader Part 1"
echo 'tftp ${loadaddr}' ${uboot1} > ${port}
echo > ${port}
sleep 10
echo " 6/22 - Install Bootloader Part 1"
echo 'nand erase.part u-boot-spl' > ${port}
echo > ${port}
sleep 5
echo 'nand write ${fileaddr} u-boot-spl ${filesize}' > ${port}
echo > ${port}
sleep 10
echo " 7/22 - Transfer Bootloader Part 2"
echo 'tftp ${loadaddr}' ${uboot2} > ${port}
echo > ${port}
sleep 10
echo " 8/22 - Install Bootloader Part 2"
echo 'nand erase.part u-boot' > ${port}
echo > ${port}
sleep 5
echo 'nand write ${fileaddr} u-boot ${filesize}' > ${port}
echo > ${port}
sleep 7
echo " 8/22 - Reset"
echo 'reset' > ${port}
sleep 5
echo " 9/22 - Set default environment"
echo 'env default -f -a' > ${port}
echo "10/22 - Set IP adresses"
sleep 5
echo 'setenv serverip '${IPH} > ${port}
echo 'setenv ipaddr '${IPT} > ${port}
echo "11/22 - Transfer Environment"
#copy and source predefinded environment
echo 'tftp ${loadaddr}' ${image} > ${port}
sleep 8
echo 'source ${fileaddr}' > ${port}
sleep 5
#override IP - Settings in predefined Environment
echo 'setenv serverip '${IPH} > ${port}
echo 'setenv ipaddr '${IPT} > ${port}
echo 'saveenv' > ${port}
echo "12/22 - Transfer device tree"
echo 'tftp ${loadaddr}' ${dtb} > ${port}
echo > ${port}
sleep 5
echo "13/22 - Save device tree"
echo 'nand erase.part dtb' > ${port}
echo > ${port}
sleep 2
echo 'nand write.jffs2 ${fileaddr} dtb ${filesize}' > ${port}
echo > ${port}
sleep 7
echo 'reset' > ${port}
sleep 5
echo > ${port}
#copy and install kernel
echo "14/22 - Transfer Linux Kernel"
echo 'tftp ${loadaddr}' ${kernel} > ${port}
sleep 15
echo 'nand erase.part linux' > ${port}
sleep 5
echo "15/22 - Save Linux Kernel"
echo 'nand write.jffs2 ${fileaddr} linux ${filesize}' > ${port}
sleep 5
#copy and install filesystem
echo "16/22 - Transfer Filesystem"
echo 'tftp ${loadaddr}' ${rootfs} > ${port}
sleep 25
echo 'nand erase.part rootfs' > ${port}
sleep 5
echo "17/22 - Save Filesystem"
echo 'nand write.trimffs ${fileaddr} rootfs ${filesize}' > ${port}
sleep 15
echo "18/22 - Reset and Reboot"
echo 'reset' > ${port}
sleep 3
echo > ${port}
echo > ${port}
echo "19/22 - Install Splashscreen"
echo 'nand erase.part logo.bmp' > ${port}
echo > ${port}
sleep 3
echo 'tftp ${loadaddr}' ${splash} > ${port}
sleep 5
echo > ${port}
sleep 5
echo 'nand write ${fileaddr} logo.bmp ${filesize}' > ${port}
echo > ${port}
sleep 5
echo > ${port}
#backlight is only 50% so far, set it to 100%
echo "20/22 - Set backlight to full brightness"
sleep 6
echo 'fdt set /backlight default-brightness-level <0x01>'  > ${port}
sleep 3
echo > ${port}
echo "21/22 - Save environment"
sleep 3
echo 'run fdtsave' > ${port}
sleep 3
echo "22/22 - Finished Programming!"
#ready for start
#change displaysettings
echo "Display currently set to EDT 5,7 (ETV570)"
echo "possible other video modes are:"
echo "1: ET0350		ET0350G0DH6"
echo "2: ET0430		ET0430G0DH6"
echo "3: ET0500		ET0500G0DH6"
echo "4: ETQ570		ETQ570G0DH6 or ETQ570G2DH6"
echo "5: ET0700		ET0700G0DH6"
echo "6: VGA		standard VGA"
echo "change video mode? (y/n)"
#echo
read video_decision
if [ "$video_decision" != y ]
    then
        echo "Video resolution set to ETV570, exiting now!"
        exit
    else
         echo "Please enter number of desired video mode (1-6)"
         read video_mode
         if [ "$video_mode" = 1 ]
            then
                echo 'setenv video_mode ET0350' > ${port}
                echo 'saveenv' > ${port}
                sleep 3
                echo "Finished!"
         elif [ "$video_mode" = 2 ]
            then
                echo 'setenv video_mode ET0430' > ${port}
                echo 'saveenv' > ${port}
                sleep 3
                echo "Finished!"
         elif [ "$video_mode" = 3 ]
            then
                echo 'setenv video_mode ET0500' > ${port}
                echo 'saveenv' > ${port}
                sleep 3
                echo "Finished!"
         elif [ "$video_mode" = 4 ]
            then
                echo 'setenv video_mode ETQ570' > ${port}
                echo 'saveenv' > ${port}
                sleep 3
                echo "Finished!"
         elif [ "$video_mode" = 5 ]
            then
                echo 'setenv video_mode ET0700' > ${port}
                echo 'saveenv' > ${port}
                echo > ${port}
                sleep 3
                #we need to invert the pixelclock for the 7". Otherwise the output won't be correct and some pixels are strange
                echo 'fdt set display/display-timings/timing4/ pixelclk-active <0>' > ${port}
                sleep 3
                echo > ${port}
                sleep 3
                echo 'nand erase.part dtb' > ${port} #fixme run fdtsave
                echo > ${port}
                sleep 3
                echo 'nand write.jffs2 ${fdtaddr} dtb' > ${port}
                echo > ${port}
                sleep 3
                echo "Finished!"
         else [ "$video_mode" = 6 ]
            echo 'setenv video_mode VGA' > ${port}
            echo 'saveenv'
            sleep 3
            echo "Finished!"
         fi
fi
