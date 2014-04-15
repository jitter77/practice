#!/usr/bin/env python2.7
#_*_ coding: utf-8 _*_

__author__ = 'dp'

OS = ["WinCE6", "WinEC7", "Android", "Linux"]

chosen_os = ()


def main():
    """Available OS"""
    m = 1
    for i in OS:
        print m, ":", (i)
        m += 1
    chosen_os = input("Number of OS: ")
    if chosen_os == 1:
        chosen_os = "WinCE6"
    elif chosen_os == 2:
        chosen_os = "WinEC7"
    elif chosen_os == 3:
        chosen_os = "Android"
    elif chosen_os == 4:
        chosen_os = "Linux"
    print "Chosen OS: %s\n" % chosen_os
    return chosen_os

if __name__ == '__main__':
    main()
