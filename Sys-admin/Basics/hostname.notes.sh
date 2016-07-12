#!/bin/bash
# -*- coding: UTF8 -*-

##
#   Bash basics notes : hostname-related snippets.
#
#   Tested on Debian 8
#   @timestamp 2016/04/17 17:54:43
#
#   Example values :
#   Old hostname was lan-0-12.io
#   → new : lan-0-61.io
#
#   Sources :
#   http://www.pontikis.net/blog/debian-jessie-web-server-setup
#   http://serverfault.com/questions/490825/how-to-set-the-domain-name-on-gnu-linux
#

#   Systemd ships a growing number of useful, unified command-line interfaces
#   for system settings and control (timedatectl, bootctl, hostnamectl,
#   loginctl, machinectl, kernel-install, localectl).
#   In Debian, they use the existing configuration files without breaking
#   compatibility. Using systemd is easy to change hostname :

hostnamectl set-hostname lan-0-61.io


#------------------------------------------------------------------------------

#   [old way to] Change server's hostname.
#   The content of /etc/hostname is the hostname.
#   (as root or sudo)
echo "lan-0-61.io" > /etc/hostname

#   Activate hostname
hostname -F /etc/hostname

#   Replace old domain in hosts file.
sed -e 's,lan-0-12.io,lan-0-61.io,g' -i /etc/hosts

#   Likely need to restart.
reboot
