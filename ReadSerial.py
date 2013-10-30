__author__ = 'dp'

import serial
sCom1 =serial.Serial(0)
sCom1.setBaudrate(115200)
if sCom1.isOpen()==False:
    sCom1.open()

while(1):
    line = sCom1.readline()
    print line
sCom1.close()

