#_*_ coding: utf-8 _*
"""Tool to read and write from/to /dev/tty, write log if wanted"""
__author__ = 'dp'
version = '0.1'

Port = "/dev/ttyS0"
#!/usr/bin/python

#TODO Logdatei
#TODO Lokal arbeiten oder Images herunterladen
#TODO Erstinstallation, defaults (Sprache, Pfade) speichern
#TODO Proxy?
#TODO GIT PULL!!!
#TODO tftp starten
#TODO freie IPs abfragen eigene: ifconfig | grep inet
#TODO ENV files anlegen
#TODO Übergabewerte (data, ausgelesenes Environment)
#TODO Dictonary Modul, Env_File, Kernel, RootFS
#TODO CompactTFT




import os
import sh
import time
import platform
import urllib2
import serial
import pickle

#Dictionaries; auslagern?
TX28 = dict(linux_uboot='uImage_tx28', rootfs_gpe='', rootfs_polytouch='', rootfs_qt_embedded='mucross-1.5-qt-embedded-demo-tx28.jffs2', nand_env_linux='')
TX28S = dict(linux_uboot='uImage_tx28s', rootfs_gpe='', rootfs_polytouch='', rootfs_qt_embedded='', nand_env_linux='')
TX48 = dict(linux_uboot='uImage_tx48', rootfs_gpe='', rootfs_polytouch='', rootfs_qt_embedded='', nand_env_linux='', nand_env_android='', nand_env_wince='')
TX53 = dict(linux_uboot='uImage_tx53', rootfs_gpe='', rootfs_polytouch='', rootfs_qt_embedded='', nand_env_linux='', nand_env_android='', nand_env_wince='')
TX6DL = dict(linux_uboot='uImage_txdl', rootfs_gpe='', rootfs_polytouch='', rootfs_qt_embedded='', nand_env_linux='', nand_env_android='', nand_env_wince='')
TX6Q = dict(linux_uboot='uImage_tx6q', rootfs_gpe='', rootfs_polytouch='', rootfs_qt_embedded='', nand_env_linux='', nand_env_android='', nand_env_wince='')

Baudrate = ["9600", "19200", "38400", "57600", "115200"]
Module = ["TX25", "TX28", "TX28S", "TX48", "TX53", "TX6DL", "TX6Q"]
OS = ["WinCE6", "WinEC7", "Android", "Linux"]


version_pickle = pickle.HIGHEST_PROTOCOL
#tree = ['/files_flasher/modules/tx25/os/linux/', '/files_flasher/modules/tx28/os/linux/']

#Wurde unter Linux gestartet?
if platform.system() != "Linux":
    print ("Only for Linux (so far)!")

#Check ob Programm mit root - Rechten aufgerufen wurde
user = os.geteuid()
if user != 0:
    print "You have to be root! Start program as root or using sudo!\nExiting now."
    quit()

#check for update
update = raw_input("\nCheck for updates? y/n ")
if update in ['y', 'Y', 'ye', 'yes', 'Ye', 'Yes', 'YES', 'YE']:
    version_web = urllib2.urlopen("http://www.die-resterampe.de/flasher_version").read()
    if version < version_web:
        print "**********************************************"
        print "* Update available! Please load new version! *"
        print "* Please visit: www.LINK.de                  *"
        print "**********************************************"
        # 3 Sekunden warten, Link einblenden
        time.sleep(3)
        upgrade = input("Update now? y/n")
        if upgrade in ['y', 'Y', 'ye', 'yes', 'Ye', 'Yes', 'YES', 'YE']:
            pass
    else:
        print "Version is up to date\n"
        # 3 Sekunden warten
        time.sleep(3)


def ip_adresses():
    '''IP Host und Device auslesen bzw setzen'''
    check = sh.ifconfig
    check = sh.grep("inet")
    print check

#TODO first run auslagern
def first_run(baud, Version, version_flash):
    """first run, conf erstellen, werte eintragen"""
    heim = os.getenv("HOME")
    #TODO Version in settings.conf einfügen! Für aktuellere Downloads! Oder doch nicht: git pull!
    try:
        if os.path.exists(heim + "/files_flasher/settings.conf " + version_flash):
            pass
        else:
            tree = urllib2.urlopen("http://www.die-resterampe.de/pfade").readlines()

            for zeile in tree:
                os.makedirs(heim + zeile)
                #file(heim+"/files_flasher/settings.conf")
        with open(heim + "/files_flasher/settings" + version_flash + ".conf", 'wb') as datei:
            pickle.dump("test", datei, protocol=version_pickle)
            #datei.close()
    except IOError:
        print ("IOError!")



print ("Moegliche Baudraten: ")
for i in Baudrate:
    print (i)
first_run(baud=Baudrate, Version=version_pickle, version_flash=version)
baud = input("Baudrate waehlen: ")

#TODO log, Funktion?
log = raw_input("Logdatei erstellen? y or n: ")

if log in ['y', 'Y', 'ye', 'yes', 'Ye', 'Yes', 'YES', 'YE']:
    heim = os.getenv("HOME")
    logdatei = file(heim + "/files_flasher/logs/systemlog " + time.strftime("%d_%m_%Y"), "w+")
elif log in ['n', 'no', 'N', 'No', 'NO']:
    print ("no log will be generated")
else:
    print ("please answer y or n!")


def get_time(time):
    """Zeit im Format Stunde/Minute/Sekunde auslesen und zurückgeben"""
    print time.strftime("%H:%M:%S")
    test = str(time.strftime("%H:%M:%S"))
    print test


def write_log(data):
    """Logdatei öffnen, Zeilennummer und Zeitstempel einfügen, Zeilen schreiben, Datei schließen"""
    datei = open(logdatei, "w+")
    print(data)
    datei.close()


def open_com(sCom1=Port):
    """ComPort oeffnen"""
    #sCom1 = serial(port="/dev/ttyS0")
    sCom1.setBaudrate(baud)
    if sCom1.isOpen() == False:
        sCom1.open()

        #sCom1 =serial.Serial(port="/dev/ttyS0")
        #sCom1.setBaudrate(baud)
        #Schnittstelle oeffnen
        #if sCom1.isOpen()==False:
        #   sCom1.open()


def read_com(data, sCom1=Port):
    """Com oeffnen, lesen bis keine Zeichen mehr kommen, in logdatei schreiben, Schnittstelle schliessen"""
    open_com()
    while (): #zu implementieren: kommen noch Zeichen?
        line = sCom1.read()
        print (line)
        sCom1.close()

        #while(1): #bis kein Inhalt mehr kommt
        #von Schnittstelle lesen
        #   line = sCom1.readline()
        #  print (line)
        #Schnittstelle schliessen
        #sCom1.close()



    #while(): #bis Datei komplett gelesen
    #   line = sCom1.writelines(lines) #lines: Auszulesende Zeilen
    #  print(line)

#sCom1.close()

def read_env(env_datei, data):
    """Environment Zeile für Zeile einlesen / an Port senden"""
    befehle = open(env_datei)
    for zeile in befehle:
        print zeile
        write_com(data)
    env_datei.close()


def write_com(data, sCom1=Port):
    """Com oeffnen, Daten einlesen bis kein Input, Daten schreiben, Com schliessen"""
    open_com()
    #for zeile in datei:

    while ():
        line = sCom1.write(data=test)
        sCom1.close()


def run_tftp():
    """tftp Server starten"""
    os.popen("/etc/init.d/tftpd-hpa restart")
