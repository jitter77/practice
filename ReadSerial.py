#!/usr/bin/env python2.7
#_*_ coding: utf-8 _*
"""Tool to read and write from/to /dev/tty, write log if wanted"""
__author__ = 'dp'
if __name__ == 'main':
    main()

version = '0.1'






#TODO wiederkehrende Teile als Klasse anlegen
#TODO Logdatei
#TODO Lokal arbeiten oder Images herunterladen
#TODO Erstinstallation, defaults (Sprache, Pfade) speichern
#TODO Proxy?
#TODO GIT PULL!!!
#TODO freie IPs abfragen eigene: ifconfig | grep inet
#TODO ENV files anlegen
#TODO Übergabewerte (data, ausgelesenes Environment)
#TODO Dictonary Modul, Env_File, Kernel, RootFS
#TODO weiteres Modul flashen?




import os
import sh
import time
import platform
import urllib2
import serial
import pickle



port = "/dev/ttyS0"
version_pickle = pickle.HIGHEST_PROTOCOL


#TODO Dictionaries; auslagern?
TX28 = dict(linux_uboot='uImage_tx28', rootfs_gpe='tx28_gpe.jffs2', rootfs_polytouch='tx28_poly.jffs2',
            rootfs_qt_embedded='tx28_qt.jffs2', nand_env_linux='tx28_env_linux')
TX28S = dict(linux_uboot='uImage_tx28s', rootfs_gpe='tx28s_gpe.jffs2', rootfs_polytouch='tx28s_poly.jffs2',
             rootfs_qt_embedded='tx28s_qt.jffs2', nand_env_linux='tx28s_env_linux')
TX48 = dict(linux_uboot='uImage_tx48', rootfs_gpe='tx48_gpe.jffs2', rootfs_polytouch='tx48_poly.jffs2',
            rootfs_qt_embedded='tx48_qt.jffs2', nand_env_linux='tx48_env_linux',
            nand_env_android='tx48_env_android', nand_env_wince='tx48_env_wince')
TX53 = dict(linux_uboot='uImage_tx53', rootfs_gpe='tx53_gpe.jffs2', rootfs_polytouch='tx53_poly.jffs2',
            rootfs_qt_embedded='tx53_qt.jffs2', nand_env_linux='tx53_env_linux',
            nand_env_android='tx53_env_android', nand_env_wince='tx53_env_wince')
TX6DL = dict(linux_uboot='uImage_txdl', rootfs_gpe='tx6dl_gpe.jffs2', rootfs_polytouch='tx6dl_poly.jffs2',
             rootfs_qt_embedded='tx6dl_qt.jffs2', nand_env_linux='tx6dl_env_linux',
             nand_env_android='tx6dl_env_android', nand_env_wince='tx6dl_env_wince')
TX6Q = dict(linux_uboot='uImage_tx6q', rootfs_gpe='tx6q_gpe.jffs2', rootfs_polytouch='tx6q_poly.jffs2',
            rootfs_qt_embedded='tx6q_qt.jffs2', nand_env_linux='tx6q_env_linux',
            nand_env_android='tx6dl_env_android', nand_env_wince='tx6dl_env_wince')
CompactTFT = dict(linux_uboot='', rootfs_gpe='', rootfs_polytouch='', roootfs_qt_embedded='', nand_env_linux='',
                  nand_env_android='', nand_env_wince='')

Baudrate = ["9600", "19200", "38400", "57600", "115200"]
Module = ["TX25", "TX28", "TX28S", "TX48", "TX53", "TX6DL", "TX6Q", "CompactTFT"]
OS = ["WinCE6", "WinEC7", "Android", "Linux"]


#tree = ['/files_flasher/modules/tx25/os/linux/', '/files_flasher/modules/tx28/os/linux/']

#Wurde unter Linux gestartet?
if platform.system() != "Linux":
    print ("Only for Linux (so far)!")

#Check ob Programm mit root - Rechten aufgerufen wurde
user = os.geteuid()
if user != 0:
    print "-" * 40
    print "|You have to be root!", " " * 16, "|"
    print "|Start program as root or using sudo!  |"
    print "|Exiting now.", " " * 24,  "|"
    print "-" * 40
    #3 Sekunden warten
    time.sleep(3)
    quit()

#check for update
print("-") * 26
update = raw_input("| Check for updates? y/n |")
print("-") * 26
if update in ['y', 'Y', 'ye', 'yes', 'Ye', 'Yes', 'YES', 'YE']:
    version_web = urllib2.urlopen("http://www.die-resterampe.de/flasher_version").read()
    if version < version_web:
        print "-" * 40
        print "| Update available! Please load new version! |"
        print "| Please visit: www.LINK.de ", " " * 15, "|"
        print "|" * 40
        # 3 Sekunden warten, Link einblenden
        time.sleep(3)
        upgrade = input("Update now? y/n")
        if upgrade in ['y', 'Y', 'ye', 'yes', 'Ye', 'Yes', 'YES', 'YE']:
            pass
    else:
        print "Version is up to date\n"
        # 3 Sekunden warten
        time.sleep(3)
else:
    pass


def ip_adresses():
    """IP Host und Device auslesen bzw setzen"""
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

#Vielleicht mal den folgenden Rattenschwanz als Funktion mit Dictionary vereinfachen?
print ("\nMoegliche Baudraten:\n(Bitte Zahl zw. 1 und 5 wählen) ")
print("-") * 22
n = 1
for i in Baudrate:
    print n, ":", (i)
    n = n + 1
    #print (i)
#first_run(baud=Baudrate, Version=version_pickle, version_flash=version)
select = input("\nBaudrate wählen: ")
if select == 1:
    baud = 9600
elif select == 2:
    baud = 19200
elif select == 3:
    baud = 38400
elif select == 4:
    baud = 57600
elif select == 5:
    baud = 115200
else:
    print "Bitte Zahl zwischen 1 und 5 eingeben!\nExit!"
    print "-" * 35
    time.sleep(3)
    quit()

class flash:
    def __init__(self, port, datei,env_datei,logdatei ):
        self.port = port
        self.datei = datei
        self.env_datei
        self.data
        self.logdatei


    def read_env(self, env_datei, data):
        """Environment Zeile für Zeile einlesen / an Port senden"""
        befehle = open(env_datei)
        for zeile in befehle:
            print zeile
            write_com(data)
        env_datei.close()

    def read_com(self, data, port):
        """Com oeffnen, lesen bis keine Zeichen mehr kommen, in logdatei schreiben, Schnittstelle schliessen"""
        open_com()
        while ():  #zu implementieren: kommen noch Zeichen?
            line = port.read()
            print (line)
        port.close()

        #while(1): #bis kein Inhalt mehr kommt
        #von Schnittstelle lesen
        #   line = sCom1.readline()
        #  print (line)
        #Schnittstelle schliessen
        #sCom1.close()
    def write_log(self, logdatei, data):
        """Logdatei öffnen, Zeilennummer und Zeitstempel einfügen, Zeilen schreiben, Datei schließen"""
        datei = open(logdatei, "w+")
        print(data)
        datei.close()

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

def open_com(port):
    """ComPort oeffnen"""
    #sCom1 = serial(port="/dev/ttyS0")
    port.setBaudrate(baud)
    if port.isOpen() == False:
        port.open()

        #sCom1 =serial.Serial(port="/dev/ttyS0")
        #sCom1.setBaudrate(baud)
        #Schnittstelle oeffnen
        #if sCom1.isOpen()==False:
        #   sCom1.open()






        #while(): #bis Datei komplett gelesen
        #   line = sCom1.writelines(lines) #lines: Auszulesende Zeilen
        #  print(line)


#sCom1.close()




def write_com(data, port):
    """Com oeffnen, Daten einlesen bis kein Input, Daten schreiben, Com schliessen"""
    open_com()
    #for zeile in datei:

    while ():
        line = port.write(data=test)
        port.close()


def run_tftp():
    """tftp Server starten"""
    os.popen("/etc/init.d/tftpd-hpa restart")
