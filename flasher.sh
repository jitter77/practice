#!/bin/bash
################################################
# Tool to program a Demo on several Karo TX    #
#                                       boards #
# Please send feedback to:                     #
# dominik.peuker@glyn.de                       #
# Dominik Peuker November 2014                 #
# Glyn Gmbh & Co. KG                           #
#                                              #
#History                                       #
#----------------------------------------------#
#0.1 - 20.01.2015 - Initial Version            #
#0.9 - 26.02.2015 - Several Boards added. File #
#                   working                    #
#0.9.1 - 26.05.2015 - TX5A added               #
#0.9.2 - 16.09.2015 - TX6UL added              #
################################################

#presets
demo=0
#available modules (so far):
#TX28S(4130), TX28(4031), TX28(4032), TX48(7020), TX53(8030),
#TX6UL(5010),TX6UL(5011), TX6S(8034), TX6S(8035), TX6DL(8030), TX6DL(8033) TX6Q(1010), TX6Q(1020), TX6Q(1030)
#TX5A(5010), TX5A(5011)
#
#Configuration
#-------------
#
#Freescale
#---------
#TX28S-4130:
#i.MX287 - 454MHz - 64MB RAM - 128MB NAND - TTL output
#
#TX28-4031:
#i.MX287 - 454MHz - 128MB RAM - 128MB NAND - TTL output
#
#TX28-4032:
#i.MX287 - 454MHz - 256MB RAM - 128MB NAND - TTL output
#
#TXUL-5010:
#i.MX6G2 - 528MHz - 265MB RAM - 128MB NAND  - TTL output
#
#TXUL-5011:
#i.MX6G2 - 528MHz - 256MB RAM - 4GB eMMC - TTL output
#
#TX6S-8034:
#i.MX6S7 - 800MHz - 256MB RAM - 128MB NAND - TTL output
#
#TX6S-8035:
#i.MX6S7 - 800MHz - 512MB RAM - 4GB eMMC - TTL output
#
#TX6U-8030:
#i.MX6U7 - 2x800MHz - 1GB RAM - 128MB NAND - TTL output
#
#TX6U-8033:
#i.MX6u7 - 2x800MHz - 1GB RAM - 4GB eMMC - TTL output
#
#TX6Q-1010 / TX6Q1030:
#i.MX6Q5 - 4x1GHz - 1GB RAM - 128MB NAND - TTL output
#
#TX6Q-1020:
#i.MX6Q5 - 4x1GHz - 1GB RAM - 8GB eMMC - TTL output
#
#Texas Instruments:
#------------------
#TX48-7020:
#AM3354 - 720MHz - 256MB RAM - 128MB NAND - TTL output
#
#Atmel:
#------
#TXA5-5010:
#SAMA5D42 - 528MHz - 256MB RAM - 128MB NAND - TTL output
#
#TXA5-5011:
#SAMA5D42 - 528MHz - 256MB RAM - 4GB eMMC - TTL output

com=0
path=~/PycharmProjects/practice/    #FIXME for release
clear
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
#echo "11: TX5A (TX5A-5010)"
#echo "12: TX5A (TX5A-5020)"
#echo "13: TX6UL (TX6UL-5010)"
#echo "14: TX6UL (TX6UL-5011)" Fixme Change order of modules when available
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
    #13) com=TX6UL; echo "Chosen Module:" ${com};;
    #14) com=TX6ULemmc; echo "Chosen Module:" ${com};;
    *) echo "Please enter number between 1 & 14! Exiting now."; exit 0;;
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
    3) demo=term; echo "Chosen Demo: µcross-Terminal"; sleep 3;;
    4) demo=qt; echo "Chosen Demo: Qt Application"; sleep 3;;
    5) demo=yocto; echo "Chosen Demo: Yocto Application. Not yet available!"; sleep 3;; #FIXME when ready
    *) echo "Please choose number between 1 & 5! Exiting now."; exit 0;;
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
    "TX28Spoly") exec /bin/sh ${path}polytouch_tx28s.sh; exit 0;;
    "TX28Sgpe") exec /bin/sh ${path}gpe_tx28s.sh; exit 0;;
    "TX28Sterm") exec /bin/sh ${path}terminal_tx28s.sh; exit 0;;
    "TX28Sqt") exec /bin/sh ${path}qt_tx28s.sh; exit 0;;
    "TX28Syocto") echo "Not available! Exiting now."; exit 0;;
    #TX28(4030)
    "TX28poly") exec /bin/sh ${path}polytouch_tx28.sh; exit 0;;
    "TX28gpe") exec /bin/sh ${path}gpe_tx28.sh; exit 0;;
    "TX28term") exec /bin/sh ${path}terminal_tx28.sh; exit 0;;
    "TX28qt") exec /bin/sh ${path}qt_tx28.sh; exit 0;;
    "TX28yocto") echo "Not available! Exiting now."; exit 0;;
    #TX48(7020)
    "TX48poly") exec /bin/sh ${path}gpe_tx48.sh; exit 0;;
    "TX48gpe") exec /bin/sh ${path}gpe_tx48.sh; exit 0;;
    "TX48term") exec /bin/sh ${path}terminal_tx48.sh; exit 0;;
    "TX48qt") exec /bin/sh ${path}qt_tx48.sh; exit 0;;
    "TX48yocto") echo "Not available! Exiting now."; exit 0;;
    #TX53(8030)
    "TX53poly") exec /bin/sh ${path}; exit 0;;
    "TX53gpe") exec /bin/sh ${path}; exit 0;;
    "TX53term") exec /bin/sh ${path}; exit 0;;
    "TX53qt") exec /bin/sh ${path}; exit 0;;
    "TX53yocto") echo "Not available! Exiting now."; exit 0;;
    #TX6DLemmc(8033)
    "TX6DLemmcpoly") exec /bin/sh ${path}polytouch_tx6dl_8033.sh; exit 0;;
    "TX6DLemmcgpe") exec /bin/sh ${path}gpe_tx6dl_8033.sh; exit 0;;
    "TX6DLemmcterm") exec /bin/sh ${path}terminal_tx6dl_8033.sh; exit 0;;
    "TX6DLemmcqt") exec /bin/sh ${path}qt_tx6dl_8033.sh; exit 0;;
    "TX6DLemmcyocto") echo "Not available! Exiting now."; exit 0;;
    #TX6S(8034)
    "TX6Spoly") exec /bin/sh ${path}polytouch_tx6s_8034.sh; exit 0;;
    "TX6Sgpe") exec /bin/sh ${path}gpe_tx6s_8034.sh; exit 0;;
    "TX6Sterm") exec /bin/sh ${path}terminal_tx6s_8034.sh; exit 0;;
    "TX6Sqt") exec /bin/sh ${path}qt_tx6s_8034.sh; exit 0;;
    "TX6Syocto") echo "Not available! Exiting now."; exit 0;;
    #TX6Semmc(8035)
    "TX6Semmcpoly") exec /bin/sh ${path}; exit 0;;
    "TX6Semmcgpe") exec /bin/sh ${path}; exit 0;;
    "TX6Semmcterm") exec /bin/sh ${path}; exit 0;;
    "TX6Semmcqt") exec /bin/sh ${path}; exit 0;;
    "TX6Semmcyocto") echo "Not available! Exiting now."; exit 0;;
    #TX6DL(8030)
    "TX6DLpoly") exec /bin/sh ${path}polytouch_tx6dl_8030.sh; exit 0;;
    "TX6DLgpe") exec /bin/sh ${path}gpe_tx6dl_8030.sh; exit 0;;
    "TX6DLterm") exec /bin/sh ${path}terminal_tx6dl_8030.sh; exit 0;;
    "TX6DLqt") exec /bin/sh ${path}qt_tx6dl_8030.sh; exit 0;;
    "TX6DLyocto") echo "Not available! Exiting now."; exit 0;;
    #TX6Q(1010/1030)
    "TX6Qpoly") exec /bin/sh ${path}polytouch_tx6q_1030.sh; exit 0;;
    "TX6Qgpe") exec /bin/sh ${path}gpe_tx6q_1030.sh; exit 0;;
    "TX6Qterm") exec /bin/sh ${path}terminal_tx6q_1030.sh; exit 0;;
    "TX6Qqt") exec /bin/sh ${path}qt_tx6q_1030.sh; exit;;
    "TX6Qyocto") echo "Not available! Exiting now."; exit 0;;
    #TX6Q(1020)
    "TX6Qemmcpoly") exec /bin/sh ${path}; exit 0;;
    "TX6Qemmcgpe") exec /bin/sh ${path}; exit 0;;
    "TX6Qemmcterm") exec /bin/sh ${path}; exit 0;;
    "TX6Qemmcqt")  exec /bin/sh ${path}; exit 0;;
    "TX6Qemmcyocto") echo "Not available! Exiting now."; exit 0;;
    #TX5A-5010
    #"TX5Apoly") exec /bin/sh ${path}; exit 0;;
    #"TX5Agpe") exec /bin/sh ${path}; exit 0;;
    #"TX5Aterm") exec /bin/sh ${path}; exit 0;;
    #"TX5Aqt") exec /bin/sh ${path}; exit 0;;
    #"TX5Ayocto") echo "Not available! Exiting now."; exit 0;;
    #TX5A-5011
    #"TX5Aemmcpoly") exec /bin/sh ${path}; exit 0;;
    #"TX5Aemmcgpe") exec /bin/sh ${path}; exit 0;;
    #"TX5Aemmcterm") exec /bin/sh ${path}; exit 0;;
    #"TX5Aemmcqt") exec /bin/sh ${path}; exit 0;;
    #"TX5Aemmcyocto") echo "Not available! Exiting now."; exit 0;;
    #"TXUL-5010
    #"TX6ULpoly") exec /bin/sh ${path}polytouch_tx6ul_5010.sh; exit 0;;
    "TX6ULgpe") exec /bin/sh ${path}gpe_tx6ul_5010.sh; exit 0;;
    #"TX6ULterm") exec /bin/sh ${path}terminal_tx6ul_5010; exit 0;;
    #"TX6ULqt") exec /bin/sh ${path}qt_tx6ul_5010; exit 0;;
    #TX6UL-5011
    #"TX6ULemmcpoly") exec /bin/sh ${path}; exit 0;;
    #"TX6ULemmcgpe") exec /bin/sh ${path}; exit 0;;
    #"TX6ULemmcterm") exec /bin/sh ${path}; exit 0;;
    #"TX6ULemmcqt") exec /bin/sh ${path}; exit 0;;
    #"TX6ULemmcyocto") exec /bin/sh ${path}
esac
