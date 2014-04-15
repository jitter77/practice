#!/usr/bin/env python2.7
#_*_ coding: utf-8 _*_
__version__ = '0.1'


__author__ = 'dp'

rootfs = ["Console-demo", "GPE-demo", "Polytouch-demo", "Qt-demo"]

def main():
    """docstring"""
    n = 1
    for i in rootfs:
        print n, ":", (i)
        n += 1
    rootfs_chosen = input("Please choose desired filesystem!\n")
    if rootfs_chosen == 1:
        rootfs_chosen = "Console-demo"
    elif rootfs_chosen == 2:
        rootfs_chosen = "GPE-demo"
    elif rootfs_chosen == 3:
        rootfs_chosen = "Polytouch-demo"
    elif rootfs_chosen == 4:
        rootfs_chosen = "Qt-demo"
    print("Chosen filesystem: %s ") % rootfs_chosen


if __name__ == '__main__':
    main()