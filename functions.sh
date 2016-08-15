#!/bin/bash

################################################
# Tool to program a Demo on Karo TX Boards     #
# Please send feedback to:                     #
# dominik.peuker@glyn.de                       #
# Dominik Peuker October 2015                  #
# Glyn GmbH & Co. KG                           #
#                                              #
#History                                       #
#----------------------------------------------#
#0.1 - 23.10.2015 - Initial Version            #
################################################

#source Environment from Conf - File

. /$HOME/PycharmProjects/practice/flasher.conf

#source all the needed files

. /$HOME/PycharmProjects/practice/includes/bootloader.h
. /$HOME/PycharmProjects/practice/includes/filesystems_polytouch.h
. /$HOME/PycharmProjects/practice/includes/devicetrees.h
. /$HOME/PycharmProjects/practice/includes/kernels.h
. /$HOME/PycharmProjects/practice/includes/environments.h
. /$HOME/PycharmProjects/practice/includes/filesystems_gpe.h
. /$HOME/PycharmProjects/practice/includes/filesystems_console.h
. /$HOME/PycharmProjects/practice/includes/filesystems_qt.h


# just for debug
echo ${IPH}
echo ${IPT}
echo ${port}
echo ${DIR}
echo ${version}

function reset ()
{
    echo 'reset' > ${port}
    echo > ${port}
    sleep 3
    echo > ${port}

}

function flasher_env ()
{
#Keep or set IP adresses / serial port?
    echo "IP addresses currently set to:"
    echo "------------------------------"
    echo "Host: "${IPH}
    echo "Target: "${IPT}
    echo "Serial port is currently set to "${port}
    echo
    echo "Keep these settings or enter new adresses (y/N)?"
    read settings
    if [ "$settings" ==  y ] || [ "$settings" == Y ]
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
		    `clear`
    fi
}

function choose_module ()
{
#choose the KaRo - Board
    echo "Please choose your module from the list"
    echo "---------------------------------------"
    echo "1:  TX28S (TX28-4130)"
    echo "2:  TX28 (TX28-4031 / TX28-4032)"
    echo "3:  TX48 (TX48-7020)"
    echo "4:  TX53 (TX53-8030)"
    echo "5:  TX6S (TX6S-8034)"
    echo "6:  TX6S (TX6S-8035)"
    echo "7:  TX6DL (TX6U-8030)"
    echo "8:  TX6DL (TX6U-8033)"
    echo "9:  TX6Q (TX6Q-1010 / TX6Q-1030)"
    echo "10: TX6Q (TX6Q-1020)"
    #echo "11: TXA5 (TXA5-5010)"
    #echo "12: TXA5 (TXA5-5020)"
    echo "13: TXUL (TX6UL-5010)"
    #echo "14: TXUL (TX6UL-5011)" Fixme Change order of modules when available
    echo "Enter number of Module here: "
    read module
    case ${module} in
        1) com=TX28S; echo "Chosen Module:" ${com};;
        2) com=TX28; echo "Chosen Module:" ${com};;
        3) com=TX48; echo "Chosen Module:" ${com};;
        4) com=TX53; echo "Chosen Module:" ${com};;
        5) com=TX6S; echo "Chosen Module:" ${com};;
        6) com=TX6Semmc; echo "Chosen Module:" ${com};;
        7) com=TX6DL; echo "Chosen Module:" ${com};;
        8) com=TX6DLemmc; echo "Chosen Module:" ${com};;
        9) com=TX6Q; echo "Chosen Module:" ${com};;
        10) com=TX6Qemmc; echo "Chosen Module:" ${com};;
        #11) com=TX5A; echo "Chosen Module:" ${com};;
        #12) com=TX5Aemmc; echo "Chosen Module:" ${com};;
        13) com=TX6UL; echo "Chosen Module:" ${com};;
        #14) com=TX6ULemmc; echo "Chosen Module:" ${com};;
        *) echo "Please enter number between 1 & 14! Exiting now."; exit 0;;
    esac
}

function choose_demo ()
{
#choose the Filesystem
    echo "Please choose desired demo from the list"
    echo "----------------------------------------"
    echo "1: Polytouchdemo"
    echo "2: GPE - Demo"
    echo "3: Terminal"
    echo "4: Qt - Demo"
    echo "5: Yocto - Demo"
    echo "Enter number of demo (1 - 5) here: "
    read program
    case ${program} in
        1) demo=poly; echo "Chosen Demo: Polytouch"; sleep 3;;
        2) demo=gpe; echo "Chosen Demo: GPE"; sleep 3;;
        3) demo=term; echo "Chosen Demo: µcross-Terminal"; sleep 3;;
        4) demo=qt; echo "Chosen Demo: Qt Application"; sleep 3;;
        5) demo=yocto; echo "Chosen Demo: Yocto Application. Not yet available!"; sleep 3;; #FIXME when ready
        *) echo "Please choose number between 1 & 5! Exiting now."; exit 0;;
    esac
    result=${com}${demo}
    clear
    echo "Your configuration is:" ${com}${demo}
}

function clear_board ()
{
#clear all partitions
    echo "========================"
    echo "= Step: Cleaning Board ="
    echo "========================"
    echo
    echo 'nand erase.part linux' > ${port}
    sleep 3
    echo 'nand erase.part rootfs' > ${port}
    sleep 3
    echo 'nand erase.part dtb' > ${port}
    sleep 3
    #echo "Step finished"
    echo
}

function set_ip ()
{
#set ip-addresses
    echo "==============================="
    echo "=   Step: Set IP - addresses  ="
    echo "==============================="
    echo
    echo 'setenv serverip '${IPH} > ${port}
    echo > ${port}
    sleep 1
    echo 'setenv ipaddr '${IPT} > ${port}
    echo > ${port}
    sleep 1
    #echo "Step finished"
    echo
}

function set_auto ()
{
#set autoload & autostart
    echo "============================"
    echo "= Set autoload & autostart ="
    echo "============================"
    echo 'setenv autoload no' > ${port}
    echo > ${port}
    sleep 1
    echo 'setenv autostart no' > ${port}
    echo > ${port}
    sleep 1
    echo 'saveenv' > ${port}
    echo > ${port}
    sleep 1
    #echo "Step finished"
    echo
}

function update_uboot ()
{
#update the Bootloader
#TODO implement case...switch solution for tx48 and its two-stage bootloader
    echo "$uboot" #DEBUG only
    echo "==========================="
    echo "= Step: Update Bootloader ="
    echo "=   Transfer Bootloader   ="
    echo "==========================="
    echo
    sleep 5
    echo 'tftp ${loadaddr}' ${uboot} > ${port}
    echo
    sleep 10
    echo "======================="
    echo "=  Install Bootloader ="
    echo "======================="
    echo
    sleep 5
    echo 'romupdate ${fileaddr}' > ${port}
    sleep 5
    reset
    #echo "Step finished"
    echo
}

function update_environment ()
{
#update the environment
    echo "$image" #DEBUG only
    echo "==============================="
    echo "= Step: Set Board Environment ="
    echo "=     Default Environment     ="
    echo "==============================="
    echo 'env default -fa' > ${port}
    sleep 2
    set_ip
    echo "========================"
    echo "= Transfer Environment ="
    echo "========================"
    echo
#copy and source predefinded environment
    echo 'tftp ${loadaddr}' ${image} > ${port}
    sleep 8
    echo 'source ${fileaddr}' > ${port}
    sleep 5
    echo saveenv > ${port}
#override IP - Settings in predefined Environment
    set_ip
    echo
}

function flash_splash ()
{
#install a custom splashscreen
    echo "Install Splashscreen"
    echo
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
}

function update_dtb ()
{
#update the device tree
    echo "========================="
    echo "Step: Install Device Tree"
    echo "========================="
    echo
    echo 'tftp ${loadaddr}' ${dtb} > ${port}
    echo > ${port}
    sleep 3
    echo > ${port}
    #echo "Save device tree"
    echo 'nand erase.part dtb' > ${port}
    echo > ${port}
    sleep 5
    echo 'nand write.jffs2 ${fileaddr} dtb ${filesize}' > ${port}
    echo > ${port}
    sleep 3
    reset
    #echo "Step finished"
    echo
}

function update_kernel ()
{
#update the Linux kernel
    echo "========================"
    echo "= Step: Install Kernel ="
    echo "========================"
    echo
    echo 'tftp ${loadaddr}' ${kernel} > ${port}
    sleep 15
    echo 'nand erase.part linux' > ${port}
    sleep 5
    #echo "Save Linux Kernel"
    echo 'nand write.jffs2 ${fileaddr} linux ${filesize}' > ${port}
    sleep 5
    #echo "Step finished"
    echo
}

function update_rootfs ()
{
#update the filesystem
    echo ${rootfs} #Debug
    echo "============================"
    echo "= Step: Install Filesystem ="
    echo "============================"
    echo
    echo 'tftp ${loadaddr}' ${rootfs} > ${port}
    sleep 25
    echo 'nand erase.part rootfs' > ${port}
    sleep 5
    #echo "Save Filesystem"
    echo
    echo 'nand write.trimffs ${fileaddr} rootfs ${filesize}' > ${port}
    sleep 15
    reset
    #echo "Step finished"
    echo
}

function full_backlight ()
{
#set backlight to full brightness
#backlight is only 50% so far, set it to 100%
    echo "==================================="
    echo "= Step: Full backlight brightness ="
    echo "==================================="
    echo
    sleep 2
    echo 'fdt set /backlight default-brightness-level <0x01>'  > ${port}
    sleep 2
    echo > ${port}
    echo "Save Environment"
    echo
    echo 'run fdtsave' > ${port}
    echo > ${port}
    sleep 3
    echo "Step finished"
    echo
}

function set_video_mode ()
{
#set video_mode
#change displaysettings
    echo "Display currently set to EDT 5,7 (ETV570)"
    echo "possible other video modes are:"
    echo "1: ET0350		ET0350G0DH6"
    echo "2: ET0430		ET0430G0DH6"
    echo "3: ET0500		ET0500G0DH6"
    echo "4: ETQ570		ETQ570G0DH6 or ETQ570G2DH6"
#add ETV570 if "y" was entered unintentionally
    echo "5: ETV570		ETMV570"
    echo "6: ET0700		ET0700G0DH6 or ET0700G0BDH6"
    echo "7: VGA		standard VGA"
    echo "change video mode? (y/n)"
    read video_decision
    if [ "$video_decision" != y ]
        then
            echo "Video resolution set to ETV570, exiting now!"
            #exit 0
        else
             echo "Please enter number of desired video mode (1-6)"
            read video_mode
            if [ "$video_mode" = 1 ]
                then
                    echo 'setenv video_mode ET0350' > ${port}
                    echo 'saveenv' > ${port}
                    sleep 3
                    echo "Finished!"
                    #exit 0
            elif [ "$video_mode" = 2 ]
                then
                    echo 'setenv video_mode ET0430' > ${port}
                    echo 'saveenv' > ${port}
                    sleep 3
                    echo "Finished!"
                    #exit 0
            elif [ "$video_mode" = 3 ]
                then
                    echo 'setenv video_mode ET0500' > ${port}
                    echo 'saveenv' > ${port}
                    sleep 5
                    echo "Finished!"
                    #exit 0
            elif [ "$video_mode" = 4 ]
                then
                    echo 'setenv video_mode ETQ570' > ${port}
                    echo 'saveenv' > ${port}
                    sleep 3
                    #echo "Finished!"
                    #exit 0
            elif [ "$video_mode" = 5 ]
                then
                    echo 'setenv video_mode ETV570' > ${port}
                    echo 'saveenv' > ${port}
                    sleep 3
                    #echo "Finished!"
                    #exit 0
            elif [ "$video_mode" = 6 ]
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
                        echo 'fdt set display/display-timings/timing4/ pixelclk-active <0>' > ${port}
                        #TODO: ET0700      M12_ACLAVIS
                        sleep 3
                        echo 'run fdtsave' > ${port}
                        echo > ${port}
                        echo "Finished!"
                        #exit 0
                    else
                        echo "Finished!"
                        #exit 0
                    fi
            else [ "$video_mode" = 7 ]
                echo 'setenv video_mode VGA' > ${port}
                echo 'saveenv'
                sleep 3
                echo "Step finished!"
                #exit 0
            fi
    fi
}

function set_init ()
{
#pass init=/home/root/touchdemo to the module
#@ bootargs_nand
  echo "setenv bootargs_nand 'run default_bootargs;set bootargs \${bootargs} ubi.mtd=3 root=ubi0:rootfs rootfstype=ubifs rw init=/sbin/init'" > ${port}
  echo > ${port}
  echo 'saveenv' > ${port}
  echo > ${port}
#TODO let user decide wether touchdemo, slideshow, touchtest, paintdemo
}

function set_consoleblank ()
{
#@default_bootargs
  echo "setenv default_bootargs 'set bootargs console=ttyAMA0,115200 ro debug panic=1 mxsfb.mode=\${video_mode} consoleblank=0 \${append_bootargs}'" > ${port}
  sleep 5
  echo > ${port}
  echo saveenv > ${port}
  echo > ${port}
}

clear
'clear'
echo "Program Demo to Karo TX Module"
echo "------------------------------"
echo
echo "! Please check: !"
echo "-----------------"
echo ""
echo "tftp - server running?"
echo "Serial cable connected?"
echo "Ethernet connected?"
echo "TX Module inserted?" #TODO implement number of module e.g. TX28-4031
echo "Power supply connected?"
echo "continue (Y/n)"
read continue
if [ "$continue" == n ] || [ "$continue" == N ]
 then
    echo "exiting now!"
    exit 0
 else
    clear
fi

#************************************************
#*************  Main - Function  ****************
#************************************************

#**********
#setup Host
#**********

flasher_env

#******************
#get Board and demo
#******************

choose_module
#echo "${com}" #debug only
choose_demo
#echo "${com}" #debug only
#echo "${demo}" #debug only

#********************************
#clean-up to get a "fresh" board
#********************************

clear_board

#**************************
#set server- and device IPs
#**************************

set_ip

#*********************************************************
#Combine Module with Bootloader (uboot), Environment Image
#Devicetree (dtb) and Kernel
#*********************************************************

case "$com" in
    "TX28S") uboot="$uboot_tx28s";;
    "TX28") uboot="$uboot_tx28";image="$env_tx28";dtb="$dtb_tx28";kernel="$kernel_tx28";;
    "TX48") uboot="$uboot_tx48";; #FIXME
    "TX53") uboot="$uboot_tx53";image="$";dtb="$";kernel="$";;
    "TXA5") uboot="$uboot_txa5_5010";image="$";dtb="$";kernel="$";;
    "TXA5emmc") uboot="$"image="$";dtb="$";kernel="$";;
    "TXUL") uboot="$uboot_txul"image="$";dtb="$";kernel="$";;
    "TX6S") uboot="$uboot_tx6s"image="$";dtb="$";kernel="$";;
    "TX6DL") uboot="$uboot_tx6dl"image="$";dtb="$";kernel="$";;
    "TX6Q") uboot="$uboot_tx6q"image="$";dtb="$";kernel="$";;
    *) #ERROR
esac

#********************************************************************
#Combine demo string (so far "poly", "gpe", "term", "qt", and "yocto"
#with its rootfs
#********************************************************************

case "$demo" in
    "poly") rootfs="rootfs"_"$com"_"poly"; echo ${rootfs};;
    "gpe") rootfs="rootfs"_"$com"_"gpe"; echo rootfs;;
    "term") rootfs="rootfs"_"$com"_"term"; echo rootfs;;
    "qt") rootfs="rootfs"_"$com"_"qt"; echo rootfs;;
    "yocto") rootfs="rootfs_${com}_yocto"; echo rootfs;;
    *) #ERROR
esac

case "$rootfs" in
    #Polytouch Demos
    "rootfs_TX28S_poly") rootfs="$rootfs_TX28S_poly": echo ${rootfs};;
    "rootfs_TX28_poly") rootfs="$rootfs_TX28_poly"; echo ${rootfs};;
    "rootfs_TX48_poly") rootfs="$rootfs_TX48_poly"; echo ${rootfs};;
    "rootfs_TX53_poly") rootfs="$rootfs_TX53_poly"; echo ${rootfs};;
    "rootfs_TXA5_poly") rootfs="$rootfs_TXA5_poly"; echo ${rootfs};;
    "rootfs_TX6UL_poly") rootfs="$rootfs_TX6UL_poly"; echo ${rootfs};;
    "rootfs_TX6S_poly") rootfs="$rootfs_TX6S_poly"; echo ${rootfs};;
    "rootfs_TX6DL_poly") rootfs="$rootfs_TX6DL_poly"; echo ${rootfs};;
    "rootfs_TX6Q_poly") rootfs="$rootfs_TX6Q_poly"; echo ${rootfs};;
    #GPE Demos
    "rootfs_TX28S_gpe") rootfs="$rootfs_TX28S_gpe"; echo ${rootfs};;
    "rootfs_TX28_gpe") rootfs="$rootfs_TX28_gpe"; echo ${rootfs};;
    "rootfs_TX48_gpe") rootfs="$rootfs_TX48_gpe"; echo ${rootfs};;
    "rootfs_TX53_gpe") rootfs="$rootfs_TXA5_gpe"; echo ${rootfs};;
    "rootfs_TXA5_gpe") echo "Not available yet!"; exit 0;;
    "rootfs_TX6UL_gpe") rootfs="$rootfs_TX6UL_gpe"; echo ${rootfs};;
    "rootfs_TX6S_gpe") rootfs="$rootfs_TX6DL_gpe"; echo ${rootfs};;
    "rootfs_TX6DL_gpe") rootfs="$rootfs_TX6S_gpe"; echo ${rootfs};;
    "rootfs_TX6Q_gpe") rootfs= "$rootfs_TX6Q_gpe"; echo ${rootfs};;
    #Console Demos
    "rootfs_TX28S_term") rootfs="$rootfs_TX28S_term"; echo ${rootfs};;
    "rootfs_TX28_term") rootfs="$rootfs_TX28_term"; echo ${rootfs};;
    "rootfs_TX48_term") rootfs="$rootfs_TX48_term"; echo ${rootfs};;
    "rootfs_TX53_term") echo "Not avaiable yet!";;
    "rootfs_TXA5_term") rootfs="$rootfs_TXA5_term"; echo ${rootfs};;
    "rootfs_TX6UL_term") rootfs="$rootfs_TX6UL_term"; echo ${rootfs};;
    "rootfs_TX6S_term") rootfs="$rootfs_TX6S_term"; echo ${rootfs};;
    "rootfs_TX6DL_term") rootfs="$roots_TX6DL_term"; echo ${rootfs};;
    "rootfs_TX6Q_term") rootfs="$rootfs_TX6Q_term"; echo ${rootfs};;
    #Qt Demos
    "rootfs_TX28S_qt") rootfs="$rootfs_TX28S_qt"; echo ${rootfs};;
    "rootfs_TX28_qt") rootfs="$rootfs_TX28_qt"; echo ${rootfs};;
    "rootfs_TX48_qt") rootfs="$rootfs_TX48_qt"; echo ${rootfs};;
    "rootfs_TX53_qt") rootfs="$rootfs_TX53_qt"; echo ${rootfs};;
    "rootfs_TXA5_qt") echo "Not availble yet!"; exit 0;;
    "rootfs_TX6UL_qt") rootfs="$rootfs_TXUL_qt"; echo ${rootfs};;
    "rootfs_TX6S_qt") rootfs="$rootfs_TX6S_qt"; echo ${rootfs};;
    "rootfs_TX6DL_qt") rootfs="$rootfs_TX6DL_qt"; echo ${rootfs};;
    "rootfs_TX6q_qt") rootfs="$rootfs_TX6Q_qt"; echo ${rootfs};;
esac

#DEBUG only

echo "The following files will be used / programmed:"
echo "$image"
echo "$dtb"
echo "$test"
echo "$rootfs"
echo "$kernel"

#TODO check if Module is TX48, then uboot has two parts
#clear_board
update_uboot
update_environment
#flash_splash
update_dtb
update_kernel
update_rootfs
full_backlight
set_video_mode
set_init
sleep 3
set_consoleblank
sleep 3
echo "Finished!"

#***************
#End of Program
#***************

#TODO implement function to flash splashscreen
#TODO implement linuxrc. Start with init=/linuxrc first to set up pathes. Afterwards change to init=/home/root/touchdemo


