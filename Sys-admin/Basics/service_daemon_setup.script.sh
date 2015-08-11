#!/bin/bash
# -*- coding: UTF8 -*-

##
#   Setup service daemon.
#
#   Tested on Debian 8 "Jessie"
#   (as root)
#   @timestamp 2015/08/11 16:12:32
#
#   Usage :
#   Download, edit and execute this script to setup service deamon.
#   Then :
#
#   Ex.1 : Start service
#   $ service myexample start
#
#   Ex.2 : Restart service
#   $ service myexample restart
#
#   Ex.3 : Stop service
#   $ service myexample stop
#
#   Sources :
#   https://github.com/frdmn/service-daemons
#   http://blog.frd.mn/how-to-set-up-proper-startstop-services-ubuntu-debian-mac-windows/
#   

#   Script to run as a service (or deamon).
SCRIPT='myexample'
#   Optional arguments for custom script.
ARGS=''
#   Script ownership : User & group.
U='example-user'
G='example-user'
#   Script permissions.
PERM=540


#---------
#   Action

#   Make script.
cat > /usr/local/bin/$SCRIPT <<EOF
#!/bin/bash
# -*- coding: UTF8 -*-

##
#   Service daemon script
#   (Edit this optional script description)
#

#   <insert custom commands here>

EOF

#   Set script ownership & permissions.
chown $U:$G /usr/local/bin/$SCRIPT
chmod $PERM /usr/local/bin/$SCRIPT

#   Fetch @frdmn's daemon script.
wget https://raw.githubusercontent.com/frdmn/service-daemons/master/debian --quiet -O /etc/init.d/$SCRIPT

#   Edit options.
sed -e "s,NAME=\"example\",NAME=\"$SCRIPT\",g" -i /etc/init.d/$SCRIPT
sed -e "s,APPDIR=\"/usr/bin\",APPDIR=\"/usr/local/bin\",g" -i /etc/init.d/$SCRIPT
sed -e "s,APPBIN=\"python\",APPBIN=\"$SCRIPT\",g" -i /etc/init.d/$SCRIPT
sed -e "s,APPARGS=\"-m SimpleHTTPServer 8000\",APPARGS=\"$ARGS\",g" -i /etc/init.d/$SCRIPT
sed -e "s,USER=\"example\",USER=\"$U\",g" -i /etc/init.d/$SCRIPT
sed -e "s,GROUP=\"example\",GROUP=\"$G\",g" -i /etc/init.d/$SCRIPT

#   Make daemon script executable.
chmod +x /etc/init.d/$SCRIPT

#   Enable + start.
update-rc.d $SCRIPT defaults
service $SCRIPT start
