#!/bin/bash
# -*- coding: UTF8 -*-

##
#   Date & time snippets
#   
#   Should apply to most modern Linux distros
#   Tested on Debian 8
#   
#   Sources :
#   https://abdussamad.com/archives/620-Debian-Linux:-Setting-the-timezone-and-synchronizing-time-with-NTP.html
#   http://support.ntp.org/bin/view/Servers/NTPPoolServers
#   http://www.mad-hacking.net/documentation/linux/applications/ntp/ntpclient.xml
#   


#----------------------------------------------------------------------------
#       Installation

apt-get install ntpdate -y

#       The NTP Pool DNS system automatically picks time servers
#       which are geographically close for you, but if you want
#       to choose explicitly, there are sub-zones of pool.ntp.org.
#       @see http://support.ntp.org/bin/view/Servers/NTPPoolServers
ntpdate pool.ntp.org

#       Make the changes stick : set the hardware clock
hwclock --systohc


#----------------------------------------------------------------------------
#       Force update

#       as root :
service ntp stop
ntpd -gq
service ntp start


