#!/bin/bash -p
################################################
# Tool to program a polytouchdemo on Karo TX28 #
# Please send feedback to:                     #
# dominik.peuker@glyn.de                       #
# Dominik Peuker November 2014                 #
# Glyn Gmbh & Co. KG                           #
#                                              #
#History                                       #
#----------------------------------------------#
#0.1 - 20.01.2015 - Initial Version            #
################################################

#presets
clear
demo=0
com=0
echo "Please choose your module from the list"
echo "---------------------------------------"
echo "1: TX28S"
echo "2: TX28"
echo "3: TX48"
echo "4: TX53"
echo "5: TX6S"
echo "6: TX6DL"
echo "7: TX6Q"
echo "Enter number of Module here: "
read module
case ${module} in
    1) com=TX28S; echo "Chosen Module:" ${com}; sleep 3;;
    2) com=TX28; echo "Chosen Module:" ${com};;
    3) com=TX48; echo "Chosen Module:" ${com};;
    4) com=TX53; echo "Chosen Module:" ${com};;
    5) com=TX6S; echo "Chosen Module:" ${com};;
    6) com=TX6DL; echo "Chosen Module:" ${com};;
    7) com=TX6Q; "Chosen Module:" echo ${com};;
    *) echo "Please enter number between 1 & 7"
esac
clear
echo "Please choose desired demo from the list"
echo "----------------------------------------"
echo "1: Polytouchdemo"
echo "2: GPE - Demo"
echo "3: Terminal"
echo "4: Qt - Demo"
echo "Enter number of demo here: "
read program
case ${program} in
    1) demo=poly; echo ${com}; echo ${demo}; echo "Chosen Demo: Polytouch"; sleep 3; exec /bin/sh /home/dp/PycharmProjects/practice/polytouch_tx28.sh;;
    2) demo=gpe; echo "Chosen Demo: GPE"; sleep 3;;
    3) demo=term; echo "Chosen Demo: Terminal"; sleep 3;;
    4) demo=qt; echo "Chosen Demo: Qt Application"; sleep 3;;
    *) echo "Please choose number between 1 & 4"
esac
