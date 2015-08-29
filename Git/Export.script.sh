#!/bin/bash
# -*- coding: UTF8 -*-

##
#   Git script :
#   Export (as in svn export)
#
#   Install :
#   $ wget https://github.com/Paulmicha/snippets/raw/master/Git/Export.script.sh --quiet -O /usr/local/bin/gex
#   $ chmod +x /usr/local/bin/gex
#
#   Use :
#   $ gex git://someserver/somerepo path/to/dir
#
#   Sources :
#   Git clone without .git directory - http://stackoverflow.com/a/11498124/2592338
#   Do a "git export" (like "svn export") - http://stackoverflow.com/questions/160608/do-a-git-export-like-svn-export
#

#   Arg 1 : Git repo URI.
REPO_URI=$1
if [[ -z $1 ]]; then
    echo -n "Enter REPO_URI : "
    read REPO_URI
fi

#   Arg 2 : path to directory in which to export the repo.
PATH=$2
if [[ -z $2 ]]; then
    echo -n "Enter in which PATH to export ${REPO_URI} : "
    read PATH
fi

#   [optional] Arg 3 : $BRANCH to export.
#   (default : master)
BRANCH='master'
if [[ ! -z $3 ]]; then
    BRANCH=$3
    echo -e "Option detected : ${BRANCH} will be exported."
fi


#---------
#   Action

git clone --depth=1 --branch=$BRANCH $REPO_URI $PATH
rm -rf $PATH/.git
