"""Tool to read and write from/to /dev/tty"""
__author__ = 'dp'
version = '0.1'
#!/usr/bin/python
#_*_ coding: utf-8 _*_
#TODO Versionscontrolle, Logdatei, check root
import serial, os, time
#TODO Liste oder Dictionary Baudrate implementieren
Baudrate = ["9600", "115200"]
print "Moegliche Baudraten: "
for i in Baudrate:
    print i

baud = input("Baudrate waehlen: ")

sCom1 =serial.Serial(0)
sCom1.setBaudrate(baud)
#Schnittstelle oeffnen
if sCom1.isOpen()==False:
    sCom1.open()

while():
    #von Schnittstelle lesen
    line = sCom1.readline()
    print (line)
#Schnittstelle schliessen
sCom1.close()






