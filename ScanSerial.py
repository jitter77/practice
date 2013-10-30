__author__ = 'dp'

import serial


def scan_serial():
    portnames = []



# Linux
    for i in range(256):
        name = "/dev/ttyS"+str(i)
        s = serial.Serial(name)
        s.close()
        portnames.append(name)


# Linux USB
    for i in range(256):
        name = "/dev/ttyUSB"+str(i)
        s = serial.Serial(name)
        s.close()
        portnames.append(name)

    return portnames

portnames = scan_serial()
for p in portnames:
    print(p)

print(portnames)
