#!/usr/bin/env python2.7
#_*_ coding: utf-8 _*_
__version__ = '0.1'

""" This file contains all available modules and the depending bootloader. Also the available filesystems (rootfs),
 especially for linux to be flashed.
 Currently implemented Modules: TX25, TX28, TX28S, TX48, TX53, TX6U,
  TX6Q, CompactTFT (all KaRo)"""

__author__ = 'dp'

import choose_OS
import choose_rootfs
from choose_OS import chosen_os


Module = ["TX25", "TX28", "TX28S", "TX48", "TX53", "TX6DL", "TX6Q", "CompactTFT"]
TX25 = dict(linux_uboot="uImage_tx25", rootfs_gpe="tx25_gpe.jffs2", rootfs_polytouch="tx25_poly.jffs2",
            rootfs_qt_embedded="tx25_qt.jffs", nand_env_linux="tx25_env_linux")
TX28 = dict(linux_uboot="uImage_tx28", rootfs_gpe="tx28_gpe.jffs2", rootfs_polytouch="tx28_poly.jffs2",
            rootfs_qt_embedded ='tx28_qt.jffs2', nand_env_linux='tx28_env_linux')
TX28S = dict(linux_uboot='uImage_tx28s', rootfs_gpe='tx28s_gpe.jffs2', rootfs_polytouch='tx28s_poly.jffs2',
             rootfs_qt_embedded='tx28s_qt.jffs2', nand_env_linux='tx28s_env_linux')
TX48 = dict(linux_uboot='uImage_tx48', rootfs_gpe='tx48_gpe.jffs2', rootfs_polytouch='tx48_poly.jffs2',
            rootfs_qt_embedded='tx48_qt.jffs2', nand_env_linux='tx48_env_linux',
            nand_env_android='tx48_env_android', nand_env_wince='tx48_env_wince')
TX53 = dict(linux_uboot='uImage_tx53', rootfs_gpe='tx53_gpe.jffs2', rootfs_polytouch='tx53_poly.jffs2',
            rootfs_qt_embedded='tx53_qt.jffs2', nand_env_linux='tx53_env_linux',
            nand_env_android='tx53_env_android', nand_env_wince='tx53_env_wince')
TX6DL = dict(linux_uboot='uImage_txdl', rootfs_gpe='tx6dl_gpe.jffs2', rootfs_polytouch='tx6dl_poly.jffs2',
             rootfs_qt_embedded='tx6dl_qt.jffs2', nand_env_linux='tx6dl_env_linux',
             nand_env_android='tx6dl_env_android', nand_env_wince='tx6dl_env_wince')
TX6Q = dict(linux_uboot='uImage_tx6q', rootfs_gpe='tx6q_gpe.jffs2', rootfs_polytouch='tx6q_poly.jffs2',
            rootfs_qt_embedded='tx6q_qt.jffs2', nand_env_linux='tx6q_env_linux',
            nand_env_android='tx6dl_env_android', nand_env_wince='tx6dl_env_wince')
CompactTFT = dict(linux_uboot='', rootfs_gpe='', rootfs_polytouch='', roootfs_qt_embedded='', nand_env_linux='',
                  nand_env_android='', nand_env_wince='')

# U-Boot: Latest Bootloader (U-Boot). Normally called "uImage..."
# rootfs_gpe: A Linux Desktop with different applications and folders
# rootfs_polytouch: A demo with pictures and slideshow, mainly to test the EDT Polytouch
# rootfs_qt_embedded: Qt example(s)
# nand_env_linux: Bootloader-Environment for Linux
# nand_env_android: Bootloader-Environment for Android
# nand_env_wince: Bootloader-Environment for Windows

def main():
    """Modulauswahl"""
    print("-") * 26
    print("| Please choose Module   |\n| Available Modules are: |")
    print("-") * 26
    n = 1
    for i in Module:
        print n, ":", (i)
        n += 1
    print("-" * 26)
    print("\n")
    module_chosen = input("Modulenumber:\n")
    module_chosen_dict = []
    if module_chosen == 1:
        module_chosen = "TX25"
        module_chosen_dict = TX25
        print"Chosen Module:  %s\nplease choose OS:" % module_chosen
        choose_OS.main()
        print(chosen_os)
        if chosen_os == "Linux":
            choose_rootfs.main()
        else:
            pass

    elif module_chosen == 2:
        module_chosen = "TX28"
        module_chosen_dict = TX28
        print"Chosen Module:  %s\nplease choose OS:" % module_chosen
        choose_OS.main()

    elif module_chosen == 3:
        module_chosen = "TX28S"
        module_chosen_dict = TX28S
        print "Chosen Module:  %s\nplease choose OS:" % module_chosen
        choose_OS.main()

    elif module_chosen == 4:
        module_chosen = "TX48"
        module_chosen_dict = TX48
        print "Chosen Module:  %s\nplease choose OS:" % module_chosen
        choose_OS.main()

    elif module_chosen == 5:
        module_chosen = "TX53"
        module_chosen_dict = TX53
        print "Chosen Module:  %s\nplease choose OS:" % module_chosen
        choose_OS.main()

    elif module_chosen == 6:
        module_chosen = "TX6L"
        module_chosen_dict = TX6DL
        print "Chosen Module:  %s\nplease choose OS:" % module_chosen
        choose_OS.main()

    elif module_chosen == 7:
        module_chosen = "TX6Q"
        module_chosen_dict = TX6Q
        print "Chosen Module:  %s\nplease choose OS:" % module_chosen
        choose_OS.main()

    elif module_chosen == 8:
        module_chosen = "CompactTFT"
        module_chosen_dict = CompactTFT
        print"Chosen Module:  %s\nplease choose OS:" % module_chosen
        choose_OS.main()


if __name__ == '__main__':
    main()