# coding=utf-8
"""Tool to read and write from/to /dev/tty, write log if wanted"""
__author__ = 'dp'
version = '0.1'
version_web = '0'
#!/usr/bin/python
#_*_ coding: utf-8 _*_

#TODO Logdatei,http implementieren
#TODO Lokal arbeiten oder Images herunterladen
#TODO Erstinstallation, defaults (Sprache, Pfade) speichern
#TODO OS testen

import os
import time
import platform
import urllib2


import serial

#Wurde unter Linux gestartet?
if platform.system() != "Linux":
    print ("Only for Linux (so far)!")

#Check ob Programm mit root - Rechten aufgerufen wurde
user = os.geteuid()
if user != 0:
    print "You have to be root! Start program as root or using sudo!\nExiting now."
    quit()

#Versionskontrolle
urllib2.urlopen("http://nasenpappe.de/version.txt").read()
if version < version_web:
    print "Update available!"
else:
    print "Version is up to date"

def first_run():
    """first run, conf erstellen, werte eintragen"""
    pass

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
if log in ['y', 'Y', 'ye', 'yes', 'Ye', 'Yes', 'YES', 'YE']:
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


def open_com():
    """ComPort oeffnen"""
    sCom1 = serial(port="/dev/ttyS0")
    sCom1.setBaudrate(baud)
    if sCom1.isOpen()==False:
        sCom1.open()

sCom1 =serial.Serial(port="/dev/ttyS0")
sCom1.setBaudrate(baud)
#Schnittstelle oeffnen
if sCom1.isOpen()==False:
    sCom1.open()

#TODO lesen zur Funktion umbauen?!
def read_com():
    """Com oeffnen, lesen bis keien Zeichen mehr kommen, in logdatei schreiben, Schnittstelle schliessen"""
    open_com()
    while():
        line = sCom1.read()
        print (line)
        sCom1.close()

#while(1): #bis kein Inhalt mehr kommt
    #von Schnittstelle lesen
 #   line = sCom1.readline()
  #  print (line)
#Schnittstelle schliessen
#sCom1.close()

#TODO schreiben zur Funktion umbauen?!

#while(): #bis Datei komplett gelesen
 #   line = sCom1.writelines(lines) #lines: Auszulesende Zeilen
  #  print(line)
#sCom1.close()

def write_com():
    """Com oeffnen, Daten einlesen bis kein Input, Daten schreiben, Com schliessen"""
    open_com()
    while():
        line = sCom1.write(data=)
        sCom1.close()




