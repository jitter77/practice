#!/bin/sh

################################################
# Tool to program a GPE demo on Karo TX6Q      #
# Please send feedback to:                     #
# dominik.peuker@glyn.de                       #
# Dominik Peuker February 2015                 #
# Glyn Gmbh & Co. KG                           #
#                                              #
#History                                       #
#----------------------------------------------#
#0.1 - 03.02.2015 - Initial Version            #
#1.0 - 04.02.2015 - Enhanced setting for       #
#                   pixelclock of old and new  #
#                   EDT 7"                     #
#1.1 - 06.03.2015 - Change settings for        #
#                   pixelclock for 7" and run  #
#                   fdtsave                    #
################################################

clear
echo "Program GPE - Demo to TX6Q(1030)"
echo "--------------------------------"
echo
#Presetting
IPH=192.168.15.173 #Host
IPT=192.168.15.205 #Target
port=/dev/ttyUSB0
uboot=u-boot-tx6q-10x0.bin                  #Bootloader
image=setenv_poly_tx6.img                   #Environment
dtb=imx6q-tx6q-10x0.dtb                     #Device Tree
kernel=uImage_tx6                           #Linux Kernel
rootfs=mucross-2.0-gpe-demo-tx6.ubi         #GPE - demo
echo
#preparation
echo "Please check:"
echo "tftp - server running?"
echo "serial cable connected?"
echo "ethernet connected?"
echo "module TX6 (TX6Q-1030) inserted?"
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
#Mainfunction
#cleanup
echo " 1/18 - Clean Partitions"
#delete kernel
echo 'nand erase.part linux' > ${port}
sleep 3
#delete rootfs
echo 'nand erase.part rootfs' > ${port}
sleep 3
echo " 2/18 - Set IP adresses"
echo 'setenv serverip '${IPH} > ${port}
echo 'setenv ipaddr '${IPT} > ${port}
echo " 3/18 - Change autostart / autoload"
echo 'setenv autoload no' > ${port}
echo 'setenv autostart no' > ${port}
echo 'saveenv' > ${port}
echo " 4/18 - Update Bootloader"
sleep 5
echo 'tftp ${loadaddr}' ${uboot} > ${port}
echo " 5/18 - Transfering Bootloader"
sleep 10
echo " 6/18 - Installing Bootloader"
sleep 5
echo 'romupdate ${fileaddr}' > ${port}
sleep 5
echo " 7/18 - Reset"
echo 'reset' > ${port}
sleep 5
echo " 8/18 - Set default environment"
echo 'env default -f -a' > ${port}
echo " 9/18 - Set IP adresses"
sleep 5
echo 'setenv serverip '${IPH} > ${port}
echo 'setenv ipaddr '${IPT} > ${port}
echo "10/18 - Transfer Environment"
echo > ${port}
sleep 3
#copy and source predefinded environment
echo 'tftp ${loadaddr}' ${image} > ${port}
sleep 8
echo 'source ${fileaddr}' > ${port}
sleep 5
#override IP - Settings in predefined Environment
echo 'setenv serverip '${IPH} > ${port}
echo 'setenv ipaddr '${IPT} > ${port}
echo 'saveenv' > ${port}
echo > ${port}
sleep 3
echo "11/18 - Transfering device tree"
sleep 3
echo > ${port}
sleep 3
echo 'tftp ${loadaddr}' ${dtb} > ${port}
echo > ${port}
sleep 8
echo 'nand erase.part dtb' > ${port}
sleep 5
echo "12/18 - Save device tree"
echo 'nand write.jffs2 ${fileaddr} dtb ${filesize}' > ${port}
sleep 5
echo 'saveenv' > ${port}
echo 'reset' > ${port}
sleep 5
echo > ${port}
#copy and install kernel
echo "13/18 - Transfering Linux Kernel"
echo 'tftp ${loadaddr}' ${kernel} > ${port}
echo > ${port}
sleep 5
echo 'nand erase.part linux' > ${port}
echo > ${port}
sleep 5
echo "14/18 - Save Linux Kernel"
echo 'nand write.jffs2 ${fileaddr} linux ${filesize}' > ${port}
echo > ${port}
sleep 5
#copy and install filesystem
echo "15/18 - Transfering Filesystem"
echo 'tftp ${loadaddr}' ${rootfs} > ${port}
echo > ${port}
sleep 25
echo 'nand erase.part rootfs' > ${port}
echo > ${port}
sleep 5
echo "16/18 - Save Filesystem"
echo 'nand write.trimffs ${fileaddr} rootfs ${filesize}' > ${port}
sleep 15
echo "17/18 - Reset and Reboot"
echo 'reset' > ${port}
sleep 3
echo > ${port}
echo > ${port}
#backlight is only 50% so far, set it to 100%
#echo "18/20 - Set backlight to full brightness"
#sleep 6
#echo 'fdt set /backlight default-brightness-level <0x01>'  > ${port}
#sleep 3
#echo > ${port}
#sleep 3
#echo 'nand erase.part dtb' > ${port}
#sleep 3
#echo "19/20 - Save environment"
#sleep 3
#echo > ${port}
#echo 'nand write.jffs2 ${fdtaddr} dtb' > ${port}
#sleep 3
echo "18/18 - Done!"
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
                #we need to invert the pixelclock for the newer 7"
                #Otherwise the output won't be correct and some pixels are strange
                echo "For newer EDT 7 inch Displays pixelclock needs to be inverted"
                echo "Partnumber is: (G-)ETM0700G0BDH6"
                echo "Invert pixelclock? (y/n)"
                read invert
                if [ ${invert} = y ]
                    then
                    echo 'fdt set display/display-timings/ET0700/ pixelclk-active <1>' > ${port}
                    sleep 3
                    echo > ${port}
                    echo 'run fdtsave' > ${port}
                    echo > ${port}
                    sleep 1
                    echo "Finished!"
                else
                    echo "Finished!"
                fi
         else [ "$video_mode" = 6 ]
            echo 'setenv video_mode VGA' > ${port}
            echo 'saveenv'
            sleep 3
                echo "Finished!"
         fi
fi

