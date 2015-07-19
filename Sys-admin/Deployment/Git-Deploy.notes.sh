#!/bin/bash
# -*- coding: UTF8 -*-

##
#   Deployment notes :
#   Git deploy using bash (WIP)
#   
#   Goal :
#   Automatically deploy project to remote server(s) after pushing
#   
#   Prerequisites :
#   • Existing project versionned in git - privately hosted or on Bitbucket, Github, etc.
#   • Local project instance (working repo)
#   • SSH-accessible server hosting a project's instance to deploy to (remote repo)
#   
#   Steps :
#   1. Setup SSH connection & check permissions
#   2. Remote : implement post-receive hook
#   3. Local : "git remote add" newly created bare repo & test
#   
#   Usage example :
#   Supposing remote repo is added as 'staging',
#   and 'master' is the desired branch :
#   • Local : git push -u staging master
#
#   Tested on :
#   Debian 8 "Jessie" (local)
#   Ubuntu 14.04 LTS "Trusty" (remote)
#   
#   @timestamp 2015/07/18 22:52:15
#   
#   Sources :
#   http://www.sitepoint.com/one-click-app-deployment-server-side-git-hooks/
#   https://help.github.com/articles/generating-ssh-keys/
#   


#------------------------------------------------------------------------------
#   1. Setup SSH connection & check permissions


#   About ownership and permissions :
#   it is assumed that for each project hosted on the remote server,
#   a corresponding dedicated unix user exists, and owns all files and dirs (project sources & ".git").
#   From here on, the following example values (to adapt) will be used :
#       • Remote server : 192.168.0.25
#       • Remote server unix user : www-paul
#       • Git user : Paulmicha
#       • Git origin (default remote) : Bitbucket
#       • Git remote name : staging
#       • Project : paulmichalet.com
#       • Remote repo dir : /srv/paulmichalet.com
#   The following are tested in a basic LAMP stack setup (mod_php),
#   and are indicated for reference only :
#       • Remote repo ownership :
#           www-paul:www-data (all files & dirs in /srv/paulmichalet.com)
#       • Remote repo permissions :
#           600 files in ".git"
#           700 ".git" dir & sub-dirs
#           640 project files
#           750 project dirs
#           660 project files writeable by webapp
#           770 project dirs writeable by webapp


#---------------------
#   On remote server :

#   Connect as www-paul.
ssh www-paul@192.168.0.25

#   Check that "~/.ssh" dir exists, if not, create it.
if ! [ -d "$HOME/.ssh" ] ; then
    mkdir "$HOME/.ssh"
fi


#---------------------
#   On local machine :

#   If not done already, trigger addition to "known_hosts" by connecting for the first time
#   to the remote server from the local (working) machine.
#   This can output something along the lines of :
#       "The authenticity of host 192.168.0.25 can't be established.
#       RSA key fingerprint is f3:cf:58:ae:71:0b:c8:04:6f:34:a3:b2:e4:1e:0c:8b.
#       Are you sure you want to continue connecting (yes/no)?"
#   → yes
ssh www-paul@192.168.0.25
#   Then disconnect (e.g. using "Ctrl + D" terminal shortcut) to be back on the local machine.

#   Verify SSH key exists, if not, generate it.
#   Note : passphrase is optional (see below),
#   and see https://help.github.com/articles/generating-ssh-keys/ for recommendations.
if ! [ -e ~/.ssh/id_rsa.pub ] ; then
    ssh-keygen
fi

#   Send public key to remote server www-paul's "authorized_keys" file.
rsync -avzh ~/.ssh/id_rsa.pub www-paul@192.168.0.25:~/.ssh/authorized_keys

#   Verify SSH agent is running, if not, launch it
#   Note : if a passphrase was used to generate the key, "ssh-add" will prompt for it.
if [ -z "$SSH_AUTH_SOCK" ] ; then
    eval `ssh-agent -s`
    ssh-add
fi

#   Test passwordless SSH connection
#   (should not prompt for password)
ssh www-paul@192.168.0.25



#------------------------------------------------------------------------------
#   2. Remote : post-receive hook


#   On remote server, as www-paul :
#   Create the (bash) script to be executed on post-receive.
#   The following script is meant to be adapted to meet each project's needs.
#   Ex: for a Drupal site, one might want to execute additional commands, such as "drush updb -y".
echo -e '#!/bin/bash
# -*- coding: UTF8 -*-

#   Get post-receive arguments.
#   @param oldrev : previous commit SHA1 hash
#   @param newrev : latest commit SHA1 hash
#   @param refname : branch information
read oldrev newrev refname

#   Log
DATE_TIME=$(date +"%F %H:%M:%S")
LOG_DIR="$HOME/log/$(date +%Y)/$(date +%m)/$(date +%d)"
LOG_FILE="${LOG_DIR}/$(date +%H)-$(date +%M)-$(date +%M)-${newrev:0:8}.log"
if [ ! -d $LOG_DIR ] ; then
    mkdir -p $LOG_DIR
fi
echo -e "${DATE_TIME} : Received Push Request" >> $LOG_FILE
echo "Old SHA: ${oldrev}\nNew SHA: ${newrev}\nBranch Name: ${refname}\n" >> $LOG_FILE

#   Deploy "master" branch
git checkout -f master &>> $LOG_FILE

#   In case git added new files or dirs, we may have to reset their permissions.
#   (owner should already be www-paul, so chmod should be allowed)
#   TODO : group
#   chown www-paul:www-data /srv/paulmichalet.com -R
find /srv/paulmichalet.com/.git -type f -exec chmod 600 {} +
find /srv/paulmichalet.com/.git -type d -exec chmod 700 {} +
find /srv/paulmichalet.com -type f -exec chmod 640 {} +
find /srv/paulmichalet.com -type d -exec chmod 750 {} +
#find /srv/paulmichalet.com -type f -wholename "*path/to/writeable/sub/dir*" -exec chmod 660 {} +
#find /srv/paulmichalet.com -type d -wholename "*path/to/writeable/sub/dir*" -exec chmod 770 {} +

#   <Insert additional deploy steps here>
#   ex: drush updb -y

#   Closing log
DATE_TIME=$(date +"%F %H:%M:%S")
echo "\n${DATE_TIME} : Finished Deploy" >> $LOG_FILE

' > /srv/paulmichalet.com/.git/hooks/post-receive

#   Needs execution permission
chmod +x /srv/paulmichalet.com/.git/hooks/post-receive



#------------------------------------------------------------------------------
#   3. Local : "git remote add" newly created bare repo & test


#   On local machine :
#   Add new bare repo as an additional remote.
git remote add staging ssh://www-paul@192.168.0.25/srv/paulmichalet.com/.git

#   Test failed 2015/07/19 08:52:03
#       "refusing to update checked out branch
#       By default, updating the current branch in a non-bare repository
#       is denied, because it will make the index and work tree inconsistent
#       with what you pushed, and will require 'git reset --hard' to match
#       the work tree to HEAD."
git push -u staging master

#   test on remote server : no more error message, but nothing updates (even with push --force)
#   -> postponed 2015/07/19 08:54:57
cd /srv/paulmichalet.com
git config receive.denyCurrentBranch ignore

