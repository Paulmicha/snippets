#!/bin/bash
# -*- coding: UTF8 -*-

##
#   Drupal 7 Permissions - alternative dir structure
#   
#   Directory structure :
#       Files           = ./f/
#       Private Files   = ./p/
#       Tmp             = ./t/
#   
#   Install :
#   mkdir ~/custom_bash_scripts
#   wget https://github.com/Paulmicha/snippets/raw/master/Sys-admin/Drupal/7/phpfpm-fixperms-alt.script.sh --quiet --no-check-certificate --output-document="~/custom_bash_scripts/d7_phpfpm_fixperms_alt.sh"
#   chmod +x ~/custom_bash_scripts/d7_phpfpm_fixperms_alt.sh
#   
#   Use :
#   ~/custom_bash_scripts/d7_phpfpm_fixperms_alt.sh auser www-data /path/to/project-dir
#   ~/custom_bash_scripts/d7_phpfpm_fixperms_alt.sh auser www-data /path/to/project-dir 640 750 660 770
#   
#   Sources :
#   https://drupal.org/node/244924
#   

#       Param 1 : owner
#       default : current user
P_OWNER=${1}
if [ -z "${1}" ]; then
    P_OWNER="$USER"
fi

#       Param 2 : group
#       default : www-data
P_GROUP=${2}
if [ -z "${2}" ]; then
    P_GROUP="www-data"
fi

#       Param 3 : path
#       default : .
P_PATH=${3}
if [ -z "${3}" ]; then
    P_PATH="."
fi

#       Param 4 : Non-writeable Files chmod
#       default : 750
P_NWFI=${4}
if [ -z "${4}" ]; then
    P_NWFI=750
fi

#       Param 5 : Non-writeable Folders chmod
#       default : 750
P_NWFO=${5}
if [ -z "${5}" ]; then
    P_NWFO=750
fi

#       Param 6 : Writeable Files chmod
#       default : 660
P_WFI=${6}
if [ -z "${6}" ]; then
    P_WFI=660
fi

#       Param 7 : Writeable Folders chmod
#       default : 770
P_WFO=${7}
if [ -z "${7}" ]; then
    P_WFO=770
fi



#------------------------------------------------------------------------------


cd $P_PATH

#       Owner/group
chown $P_OWNER:$P_GROUP . -R

#       Non-writeable files
find . -type f -exec chmod $P_NWFI {} +

#       Non-writeable dirs
find . -type d -exec chmod $P_NWFO {} +

#       Writeable files
find . -type f -wholename "*/f/*" -exec chmod $P_WFI {} +
find . -type f -wholename "*/t/*" -exec chmod $P_WFI {} +
find . -type f -wholename "*/p/*" -exec chmod $P_WFI {} +

#       Writeable dirs
chmod $P_WFO f/
chmod $P_WFO t/
chmod $P_WFO p/
find . -type d -wholename "*/f/*" -exec chmod $P_WFO {} +
find . -type d -wholename "*/t/*" -exec chmod $P_WFO {} +
find . -type d -wholename "*/p/*" -exec chmod $P_WFO {} +

