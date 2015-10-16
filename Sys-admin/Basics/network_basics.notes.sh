#!/bin/bash
# -*- coding: UTF8 -*-

##
#   Bash basics notes : network-related snippets.
#
#   Tested on Debian 8
#   @timestamp 2015/10/08 14:30:53
#
#   Sources :
#   https://www.howtoforge.com/debian-static-ip-address
#

#   Create a backup.
#   (as root or sudo)
mv /etc/network/interfaces /etc/network/interfaces.bak

#   Write static IP (v4) on ethernet 0 - this example is on LAN.
cat > /etc/network/interfaces <<'EOF'
# This file describes the network interfaces available on your system
# and how to activate them. For more information, see interfaces(5).

source /etc/network/interfaces.d/*

# The loopback network interface
auto lo
iface lo inet loopback

# The primary network interface
allow-hotplug eth0
iface eth0 inet static
    address 192.168.0.60
    netmask 255.255.255.0
    network 192.168.0.0
    broadcast 192.168.0.255
    gateway 192.168.0.1

EOF

#   Apply modifications.
reboot
