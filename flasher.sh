#!/bin/bash
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
demo=0
com=0
path=~/PycharmProjects/practice/    #FIXME for release
clear
echo "Please choose your module from the list"
echo "---------------------------------------"
echo "1: TX28S (TX28-4130)"
echo "2: TX28 (TX28-4031)"
echo "3: TX48 (TX48-7020)"
echo "4: TX53 (TX53-8030)" #FIXME enter TX6S-8033(emmc)
echo "5: TX6S (TX6S-8034)"
echo "6: TX6SeMMC (TX6S-8035)"
echo "7: TX6DL (TX6U-8110)"
echo "8: TX6Q (TX6Q-1010)"
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
    8) com=TX6Q; echo "Chosen Module:" ${com};;
    *) echo "Please enter number between 1 & 8! Exiting now."; exit;;
esac
clear
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
    3) demo=term; echo "Chosen Demo: Terminal"; sleep 3;;
    4) demo=qt; echo "Chosen Demo: Qt Application"; sleep 3;;
    5) demo=yocto; echo "Chosen Demo: Yocto Application. Not yet available!"; sleep 3;; #FIXME when ready
    *) echo "Please choose number between 1 & 5! Exiting now."; exit;;
esac
result=${com}${demo}
#echo ${result}
clear
echo "Your configuration is:" ${com} ${demo}
#echo ${com}+${demo}
echo "Going to program this now."
sleep 3
case ${result} in
    #TX28S(4130)
    "TX28Spoly") exec /bin/sh ${path}polytouch_tx28s.sh;;
    "TX28Sgpe") exec /bin/sh ${path}gpe_tx28s.sh;;
    "TX28Sterm") exec /bin/sh ${path}terminal_tx28s.sh;;
    "TX28Sqt") exec /bin/sh ${path}qt_tx28s.sh;;
    #TX28(4030)
    "TX28poly") exec /bin/sh ${path}polytouch_tx28.sh;;
    "TX28gpe") exec /bin/sh ${path}gpe_tx28.sh;;
    "TX28term") exec /bin/sh ${path}terminal_tx28.sh;;
    "TX28qt") exec /bin/sh ${path}qt_tx28.sh;;
    #TX48(7020)
    "TX48poly") exec /bin/sh ${path}gpe_tx48.sh;;
    "TX48gpe") exec /bin/sh ${path}gpe_tx48.sh;;
    "TX48term") exec /bin/sh ${path}terminal_tx48.sh;;
    "TX48qt") exec /bin/sh ${path}qt_tx48.sh;;
    #TX53(8030)
    "TX53poly") exec /bin/sh ${path};;
    "TX53gpe") exec /bin/sh ${path};;
    "TX53term") exec /bin/sh ${path};;
    "TX53qt") exec /bin/sh ${path};;
    #TX6DLemmc(8033)
    "TX6DLemmcpoly") exec /bin/sh ${path};;
    "TX6DLemmcgpe") exec /bin/sh ${path};;
    "TX6DLemmcterm") exec /bin/sh ${path};;
    "TX6DLemmcqt") exec /bin/sh ${path};;
    #TX6S(8034)
    "TX6Spoly") exec /bin/sh ${path}polytouch_tx6s_8034.sh;;
    "TX6Sgpe") exec /bin/sh ${path}gpe_tx6s_8034.sh;;
    "TX6Sterm") exec /bin/sh ${path}terminal_tx6s.sh;;
    "TX6Sqt") exec /bin/sh ${path}qt_tx6s_8034.sh;;
    #TX6Semmc(8035)
    "TX6Semmcpoly") exec /bin/sh ${path};;
    "TX6Semmcgpe") exec /bin/sh ${path};;
    "TX6Semmcterm") exec /bin/sh ${path};;
    "TX6Semmcqt") exec /bin/sh ${path};;
    #TX6DL(8110)
    "TX6DLpoly") exec /bin/sh ${path}polytouch_tx6dl.sh;;
    "TX6DLgpe") exec /bin/sh ${path}gpe_tx6dl_8110.sh;;
    "TX6DLterm") exec /bin/sh ${path}terminal_tx6dl_8110.sh;;
    "TX6DLqt") exec /bin/sh ${path}qt_tx6dl_8110.sh;;
    #TX6Q(1010)
    "TX6Qpoly") exec /bin/sh ${path}polytouch_tx6.sh;;
    "TX6Qgpe") exec /bin/sh ${path}gpe_tx6q.sh;;
    "TX6Qterm") exec /bin/sh ${path}terminal_tx6q.sh;;
    "TX6Qqt") exec /bin/sh ${path}qt_tx6q.sh;;
esac
