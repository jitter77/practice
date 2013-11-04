# coding=utf-8
"""Tool to read and write from/to /dev/tty, write log if wanted"""
__author__ = 'dp'
version = '0.1'
version_web = '0'

Port = "/dev/ttyS0"
#!/usr/bin/python
#_*_ coding: utf-8 _*_

#TODO Logdatei,http implementieren
#TODO Lokal arbeiten oder Images herunterladen
#TODO Erstinstallation, defaults (Sprache, Pfade) speichern


import os
import time
import platform
import urllib2
import serial
import pickle

ver = pickle.HIGHEST_PROTOCOL

#Wurde unter Linux gestartet?
if platform.system() != "Linux":
    print ("Only for Linux (so far)!")

#Check ob Programm mit root - Rechten aufgerufen wurde
user = os.geteuid()
if user != 0:
    print "You have to be root! Start program as root or using sudo!\nExiting now."
    quit()

#check for update
update = raw_input("Check for updates? y/n ")
if update in ['y', 'Y', 'ye', 'yes', 'Ye', 'Yes', 'YES', 'YE']:
    urllib2.urlopen("http://www.google.de").read()
    if version < version_web:
        print "Update available!\n"
    else:
        print "Version is up to date\n"

#Versionskontrolle
def updatecheck():
    urllib2.urlopen("http://nasenpappe.de/version.txt").readline()
    if version < version_web:
        print "Update available!"
    else:
        print "Version is up to date"

def first_run(baud, Version):
    """first run, conf erstellen, werte eintragen"""
    try:
        if os.path.exists("settings.conf"):
            pass
        else:
            #datei = file("settings.conf", "w+")
            with open("settings.conf", 'wb') as datei:
                pickle.dump("test", datei, protocol=ver)
            #datei.close()
    except IOError:
            print ("IOError!")




Baudrate = ["9600", "115200"]
Module = ["TX25", "TX28", "TX28S", "TX48", "TX53", "TX6DL", "TX6Q"]
OS = ["WinCE6", "WinEC7", "Android"]
print ("Moegliche Baudraten: ")
for i in Baudrate:
    print (i)
first_run(baud=Baudrate, Version=ver)
baud = input("Baudrate waehlen: ")

#TODO log, Funktion?
log = raw_input("Logdatei erstellen? y or n: ")

if log in ['y', 'Y', 'ye', 'yes', 'Ye', 'Yes', 'YES', 'YE']:
    logdatei = file("Systemlog " + time.strftime("%d_%m_%Y"), "w+")
elif log in ['n', 'no', 'N', 'No', 'NO']:
    print ("no log will be generated")
else:
    print ("please answer y or no!")






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
    if sCom1.isOpen()==False:
        sCom1.open()

#sCom1 =serial.Serial(port="/dev/ttyS0")
#sCom1.setBaudrate(baud)
#Schnittstelle oeffnen
#if sCom1.isOpen()==False:
 #   sCom1.open()


def read_com(sCom1=Port):
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



#while(): #bis Datei komplett gelesen
 #   line = sCom1.writelines(lines) #lines: Auszulesende Zeilen
  #  print(line)
#sCom1.close()

def write_com(sCom1=Port):
    """Com oeffnen, Daten einlesen bis kein Input, Daten schreiben, Com schliessen"""
    open_com()
    while():
        line = sCom1.write(data=test)
        sCom1.close()