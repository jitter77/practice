__author__ = 'dp'
__version__ = 0.1

import os
import subprocess
port = '/dev/ttyUSB0'

"""Tool to program kernelconcepts's polytouchdemo to a KaRo TX28 board via serial cocole"""

os.popen("sh test >> 'port' setenv serverip 192.168.15.168", 'w')
