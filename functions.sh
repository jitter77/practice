#!/bin/bash

################################################
# Tool to program a Ddemo on Karo TX Boards    #
# Please send feedback to:                     #
# dominik.peuker@glyn.de                       #
# Dominik Peuker October 2015                  #
# Glyn GmbH & Co. KG                           #
#                                              #
#History                                       #
#----------------------------------------------#
#0.1 - 23.20.2015 - Initial Version            #
################################################


. /$HOME/PycharmProjects/practice/flasher.conf
echo "$IPH"
echo "$IPT"
echo "$PORT"
echo "$DIR"


function print_var() {
    echo "$var" "Der Test war falsch" $var
    var="schnubbe"
    return var

}

var=test
echo "$var"
var=bier

print_var
echo "$var"
function clear_board() {
#clear all partitions
    pass
}

function set_ip() {
#set ip-addresses and autostart
    pass

}

function update_uboot() {
#update the Bootloader
    echo "$uboot"
    pass
}

function update_environment() {
#update the environment
    pass
}

function update_dtb() {
#update the device tree
    pass

}
function update_kernel() {
#update the Linux kernel
    pass
}

function update_rootfs() {
#update the filesystem
    pass
}

function full_backlight() {
#set backlight to full brightness
    pass
}

function set_video_mode() {
#set video_mode
    pass
}

uboot="test1"
update_uboot