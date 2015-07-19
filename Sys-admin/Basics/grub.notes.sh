#!/bin/bash
# -*- coding: UTF8 -*-

##
#   Grub-related notes
#   
#   Tested on Debian 7 "wheezy"
#   
#   Sources :
#   http://unix.stackexchange.com/questions/91461/how-do-i-remove-the-timeout-in-the-boot-menu
#   

#   (as root)
#   Remove boot menu timeout
sed -e 's,GRUB_TIMEOUT=5,GRUB_TIMEOUT=0,g' -i /etc/default/grub
update-grub
reboot
