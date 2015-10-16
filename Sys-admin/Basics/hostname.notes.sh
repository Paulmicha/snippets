#!/bin/bash
# -*- coding: UTF8 -*-

##
#   Bash basics notes : hostname-related snippets.
#
#   Tested on Debian 8
#   @timestamp 2015/10/16 23:39:35
#
#   Example values :
#   Old hostname was lan-0-12.io
#   → new : lan-0-60.io
#
#   Sources :
#   http://serverfault.com/questions/490825/how-to-set-the-domain-name-on-gnu-linux
#

#   Change server's hostname.
#   The content of /etc/hostname is the hostname.
#   (as root or sudo)
echo "lan-0-60.io" > /etc/hostname

#   Activate hostname
hostname -F /etc/hostname

#   Replace old domain in hosts file.
sed -e 's,lan-0-12.io,lan-0-60.io,g' -i /etc/hosts

#   Likely need to restart.
reboot
