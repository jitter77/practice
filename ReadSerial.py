__author__ = 'dp'
#TODO Versionscontrolle, Logdatei, check root
import serial
#TODO Liste oder Dictionary Baudrate implementieren, ? help
baud = input("Set Baudrate: ")
#TODO Liste oder Dictonary mit zugehörigen Baudraten implementieren
sCom1 =serial.Serial(0)
sCom1.setBaudrate(baud)
if sCom1.isOpen()==False:
    sCom1.open()

while(1):
    line = sCom1.readline()
    print (line)
sCom1.close()

