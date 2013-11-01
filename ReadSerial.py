"""Tool to read and write from/to /dev/tty"""
__author__ = 'dp'
version = 0.1

#TODO Versionscontrolle, Logdatei, check root
import serial, os
#TODO Liste oder Dictionary Baudrate implementieren, ? help
Baudrate = {1:9600, 2:115200}
for i in Baudrate:
    print i

baud = input("Set Baudrate: ")
#TODO Liste oder Dictonary mit zugehoerigen Baudraten implementieren
sCom1 =serial.Serial(0)
sCom1.setBaudrate(baud)
if sCom1.isOpen()==False:
    sCom1.open()

while(1):
    line = sCom1.readline()
    print (line)
sCom1.close()

