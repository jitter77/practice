# coding=utf-8
"""Tool to read and write from/to /dev/tty, write log if wanted"""
__author__ = 'dp'
version = '0.1'

#!/usr/bin/python
#_*_ coding: utf-8 _*_

#TODO Logdatei,http implementieren
#TODO Lokal arbeiten oder Images herunterladen
#TODO Erstinstallation, defaults (Sprache, Pfade) speichern
#TODO OS testen

import serial, os, time

#Check ob Programm mit root - Rechten aufgerufen wurde
user = os.geteuid()
if user != 0:
    print "You have to be root! Start program as root or using sudo!\nExiting now."
    quit()

Baudrate = ["9600", "115200"]
Module = ["TX25", "TX28", "TX28S", "TX48", "TX53", "TX6DL", "TX6Q"]
OS = ["WinCE6", "WinEC7", "Android"]
print ("Moegliche Baudraten: ")
for i in Baudrate:
    print (i)

baud = input("Baudrate waehlen: ")
#TODO log, Funktion?
log = raw_input("Logdatei erstellen? y or n: ")
#log = str(log)
if log in ['y', 'Y', 'ye', 'yes', 'Ye', 'Yes']:
#TODO zeitstempel
    #Datei = ("Systemlog"+(time.strftime("%h:%m:%s"), "w"))
    logdatei = file("Systemlog", "w+")
    #logdatei = logdatei + time.strftime("%h:%m:%s")
    print time.strftime("%H:%M:%S")
    test = str(time.strftime("%H:%M:%S"))
    print test

#TODO get_time Funktion
def get_time(time):
    """Zeit im Format Stunde/Minute/Sekunde auslesen und zurückgeben"""
    pass


def write_log(data):
    """Logdatei öffnen, Zeilennummer und Zeitstempel einfügen, Zeilen schreiben, Datei schließen"""
    datei = open(logdatei, "w+")
    print(data)
    datei.close()

#TODO open Com als Funktion?

sCom1 =serial.Serial(port="/dev/ttyS0")
sCom1.setBaudrate(baud)
#Schnittstelle oeffnen
if sCom1.isOpen()==False:
    sCom1.open()

#TODO lesen zur Funktion umbauen?!

while(1): #bis kein Inhalt mehr kommt
    #von Schnittstelle lesen
    line = sCom1.readline()
    print (line)
#Schnittstelle schliessen
sCom1.close()

#TODO schreiben zur Funktion umbauen?!

while(): #bis Datei komplett gelesen
    line = sCom1.writelines(lines) #lines: Auszulesende Zeilen
    print(line)
sCom1.close()





