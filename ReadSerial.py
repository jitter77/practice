"""Tool to read and write from/to /dev/tty"""
__author__ = 'dp'
version = '0.1'
#!/usr/bin/python
#_*_ coding: utf-8 _*_
#TODO Versionscontrolle, Logdatei, check root
import serial, os, time
#TODO Liste oder Dictionary Baudrate implementieren
Baudrate = ["9600", "115200"]
print ("Moegliche Baudraten: ")
for i in Baudrate:
    print (i)

baud = input("Baudrate waehlen: ")
#TODO log, Funktion?
log = raw_input("Logdatei erstellen? y or n")
#log = str(log)
if log in ['y', 'Y', 'ye', 'yes', 'Ye', 'Yes']:
#TODO zeitstempel
    logdatei = file("Systemlog", "w")
    #logdatei = "Systemlog" and time
else:
    pass



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





