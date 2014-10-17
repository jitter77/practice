#!/usr/bin/env python2.7
# _*_ coding: utf-8 _*_
"""\Tool to read and write from/to /dev/tty, write log if wanted"""
__author__ = 'dp'
if __name__ == 'main':
    main()

__version__ = '0.1'

#TODO wiederkehrende Teile als Klasse anlegen
#TODO Logdatei - Send - Receive -Timestamp
#TODO Lokal arbeiten oder Images herunterladen
#TODO Erstinstallation, defaults (Sprache, Pfade) speichern
#TODO Proxy?
#TODO GIT PULL!!!
#TODO freie IPs abfragen eigene: ifconfig | grep inet
#TODO ENV files anlegen
#TODO Übergabewerte (data, ausgelesenes Environment)
#TODO weiteres Modul flashen?
#TODO Konfiguration vorhanden, neu?

import os
import sh
import time
import platform
import urllib2
import serial
import pickle
import list_ports
import choose_CoM

port = "/dev/ttyS0"
version_pickle = pickle.HIGHEST_PROTOCOL

Baudrate = ["9600", "19200", "38400", "57600", "115200"]


#tree = ['/files_flasher/modules/tx25/os/linux/', '/files_flasher/modules/tx28/os/linux/']
#Wurde unter Linux gestartet?
if platform.system() != "Linux":
    print "-" * 40
    print ("| Only for Linux (so far)! |")
    print ("| Exiting now!             |")
    print "-" * 40
    #3 Sekunden warten
    time.sleep(3)
    #und tschüss
    quit()

#Check, ob Programm mit root - Rechten aufgerufen wurde
user = os.geteuid()
if user != 0:
    print "-" * 40
    print "|You have to be root!", " " * 16, "|"
    print "|Start program as root or using sudo!  |"
    print "|Exiting now.", " " * 24, "|"
    print "-" * 40
    #3 Sekunden warten
    time.sleep(3)
    # und tschüss
    quit()

#check for update
print"-" * 22
print("| Check for updates? |")
print"-" * 22
update = raw_input("y/n\n")
if update in ['y', 'Y', 'ye', 'yes', 'Ye', 'Yes', 'YES', 'YE']:
    version_web = urllib2.urlopen("http://www.die-resterampe.de/flasher_version").read()
    if __version__ < version_web:
        print "-" * 40
        print "| Update available! Please load new version! |"
        print "| Please visit: www.LINK.de ", " " * 15, "|"
        print "|" * 40
        # 3 Sekunden warten, Link einblenden
        time.sleep(3)
        upgrade = input("Update now? y/n")
        if upgrade in ['y', 'Y', 'ye', 'yes', 'Ye', 'Yes', 'YES', 'YE']:
            pass
            #TODO noch implementieren
    else:
        print "Version is up to date\n"
        # 3 Sekunden warten
        time.sleep(3)
else:
    pass

#Verfügbare Ports anzeigen, Auswahl treffen, speichern
#TODO  in first run eingliedern, ansonsten gespeicherten Port behalten. Vorher gespeicherte Konfiguration anzeigen
print"-" * 26
print "-" * 26
print("| List of available ports|\n| Please choose port     |")
print "-" * 26
#Aufruf extern list_ports
list_ports.main()
port = raw_input("Please enter your port like this: /dev/ttyS0\n")
print("Chosen port: "), port


#Erstinstallation durchführen, erneuern
print("Programm einrichten?\n")
install = raw_input("y/n\n")
if install == "y":
    pass
    #TODO first run aufrufen
else:
    print("no first run")
    pass


#auslagern in first run!
def ip_adresses():
    """IP Host und Device auslesen bzw setzen"""
    check = sh.ifconfig
    check = sh.grep("inet")
    print check


#TODO first run auslagern
def first_run(baud, version, version_flash):
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
print "-" * 32
n = 1
for i in Baudrate:
    print n, ":", (i)
    n += 1
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

#Modul auswählen
choose_CoM.main()


class Flash:
    """Docstring"""

    def __init__(self, port, datei, env_datei, logdatei, data):
        self.port = port
        self.datei = datei
        self.env_datei = env_datei
        self.data = data
        self.logdatei = logdatei

    def read_env(self, env_datei, data):
        """ENV_DATEI Zeile für Zeile einlesen / DATA an Port senden"""
        befehle = open(env_datei)
        for zeile in befehle:
            print zeile
            write_com(data)
        env_datei.close()

    def read_com(self, data, port):
        """Com oeffnen, lesen bis keine Zeichen mehr kommen, in logdatei schreiben, Schnittstelle schliessen.
        data port"""
        open_com()
        while ():  # zu implementieren: kommen noch Zeichen?
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

#TODO log, Funktion? Ja! Wegen Rückprung bei Falscheingabe!
log = raw_input("Logdatei erstellen? y or n: ")

if log == "y":
    heim = os.getenv("HOME")
    logdatei = file(heim + "/files_flasher/logs/systemlog " + time.strftime("%d_%m_%Y"), "w+")
elif log == "n":
    print ("no log will be generated")
else:
    print ("please answer y or n!")


def get_time(time):
    """TIME time im Format Stunde/Minute/Sekunde auslesen und zurückgeben"""
    print time.strftime("%H:%M:%S")
    test = str(time.strftime("%H:%M:%S"))
    print test


def open_com(port):
    """
    ComPort oeffnen port
    """
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
    open_com(port)
    #for zeile in datei:

    while ():
        line = port.write(data=test)
        port.close()


#weglassen? option?
def run_tftp():
    """tftp Server starten"""
    os.popen("/etc/init.d/tftpd-hpa restart")
