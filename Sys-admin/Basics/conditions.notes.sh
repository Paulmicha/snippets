#!/bin/bash
# -*- coding: UTF8 -*-

##
#   Bash basics : conditions snippets.
#   
#   Sources :
#   http://tldp.org/LDP/Bash-Beginners-Guide/html/sect_07_01.html
#   http://www.gnu.org/software/bash/manual/html_node/Bash-Conditional-Expressions.html
#   

#   Check if file exists.
if [ -f /var/log/messages ]; then
    echo "/var/log/messages exists."
fi  
#   Check if file does not exist.
if [ ! -f /var/log/messages ]; then
    touch /var/log/messages
fi

#   Check if dir exists.
if [ -d "$HOME/.ssh" ]; then
    echo "$HOME/.ssh exists."
fi
#   Check if dir does not exist.
if [ ! -d "$HOME/.ssh" ]; then
    mkdir "$HOME/.ssh"
fi

#   Else example.
REMOTE='origin'
if [[ ! -z $4 ]]; then
    echo -e "Option detected : ${REMOTE} will be pushed to."
    REMOTE=$4
else
    echo -e "Default remote ${REMOTE} will be pushed to."
fi
