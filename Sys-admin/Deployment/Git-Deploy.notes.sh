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
#   3. Local : "git remote add" distant server repo & test
#   
#   Usage example :
#   Supposing remote repo is added as 'staging',
#   and 'master' is the desired branch :
#   • Local : git push -u staging master
#   
#   Warnings :
#   • Some security concerns are not addressed : use these notes at your own risk.
#   • Because of "git clean -df" in post-receive example script, ".gitignore" should be properly setup.
#
#   Tested on :
#   Debian 8 "Jessie" (local)
#   Ubuntu 14.04 LTS "Trusty" (remote)
#   
#   @timestamp 2015/07/22 20:14:41
#   
#   Sources :
#   http://stackoverflow.com/q/12265729
#   http://stackoverflow.com/a/28262104
#   http://stackoverflow.com/questions/6635018/reuse-git-work-tree-in-post-receive-hook-to-rm-a-few-files
#   http://stackoverflow.com/a/13057643/2592338
#   http://www.sitepoint.com/one-click-app-deployment-server-side-git-hooks/
#   https://help.github.com/articles/generating-ssh-keys/
#   http://krisjordan.com/essays/setting-up-push-to-deploy-with-git
#   


#------------------------------------------------------------------------------
#   1. Setup SSH connection & check permissions


#   About ownership and permissions :
#   it is assumed that for each project hosted on the remote server,
#   a corresponding dedicated unix user exists, and owns all files and dirs (project sources & ".git").
#   From here on, the following example values (to adapt) will be used :
#       • Remote server : 12.34.56.78
#       • Remote server unix user : www-paul
#       • Git user : Paulmicha
#       • Git origin (default remote) : Bitbucket
#       • Git remote name : staging
#       • Project : foobar.com
#       • Remote repo dir : /srv/foobar.com
#   The following are tested in a basic LAMP stack setup (mod_php),
#   and are indicated for reference only :
#       • Remote repo ownership :
#           www-paul:www-data (all files & dirs in /srv/foobar.com)
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
ssh www-paul@12.34.56.78

#   Check that "~/.ssh" dir exists, if not, create it.
if ! [ -d "$HOME/.ssh" ] ; then
    mkdir "$HOME/.ssh"
fi

#   Check installed Git version
git --version

#   Before git version 2.3 (February 2015) :
#   "git reset --hard" is needed in post-receive script (after "git checkout -f master"),
#   and the following config must be set.
#   See http://stackoverflow.com/a/28262104
cd /srv/foobar.com
git config receive.denyCurrentBranch ignore

#   Alternatively, if git version >= 2.3, that config might be set to 'updateInstead' (untested).
#git config receive.denyCurrentBranch=updateInstead


#---------------------
#   On local machine :

#   If not done already, trigger addition to "known_hosts" by connecting for the first time
#   to the remote server from the local (working) machine.
#   This can output something along the lines of :
#       "The authenticity of host 12.34.56.78 can't be established.
#       RSA key fingerprint is f3:cf:58:ae:71:0b:c8:04:6f:34:a3:b2:e4:1e:0c:8b.
#       Are you sure you want to continue connecting (yes/no)?"
#   → yes
ssh www-paul@12.34.56.78
#   Then disconnect (e.g. using "Ctrl + D" terminal shortcut) to be back on the local machine.

#   Verify SSH key exists, if not, generate it.
#   Note : passphrase is optional (see below),
#   and see https://help.github.com/articles/generating-ssh-keys/ for recommendations.
if ! [ -e ~/.ssh/id_rsa.pub ] ; then
    ssh-keygen
fi

#   Send public key to remote server www-paul's "authorized_keys" file.
rsync -avzh ~/.ssh/id_rsa.pub www-paul@12.34.56.78:~/.ssh/authorized_keys

#   Verify SSH agent is running, if not, launch it
#   Note : if a passphrase was used to generate the key, "ssh-add" will prompt for it.
if [ -z "$SSH_AUTH_SOCK" ] ; then
    eval `ssh-agent -s`
    ssh-add
fi

#   Test passwordless SSH connection
#   (should not prompt for password)
ssh www-paul@12.34.56.78



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
#   @param refname : branch information (ex: "refs/heads/master")

#   Only execute deployment when pushing on "staging" branch.
while read oldrev newrev refname
do
    branch=$(git rev-parse --symbolic --abbrev-ref $refname)
    if [ "$branch"=="staging" ]; then
        
        #   Log
        DATE_TIME=$(date +"%F %H:%M:%S")
        LOG_DIR="$HOME/log/$(date +%Y)/$(date +%m)/$(date +%d)"
        LOG_FILE="${LOG_DIR}/$(date +%H)-$(date +%M)-$(date +%M)-${newrev:0:8}.log"
        LOG_LATEST_COPY="$HOME/log/latest_post_receive.log"
        if [ ! -d $LOG_DIR ]; then
            mkdir -p $LOG_DIR
        fi
        echo -e "${DATE_TIME} : Received Push Request" >> $LOG_FILE
        echo "Old SHA: ${oldrev}\nNew SHA: ${newrev}\nBranch Name: ${refname}\n" >> $LOG_FILE

        #   For git clean to not remove actual ".git" folder contents
        #   See http://stackoverflow.com/a/6636509/2592338
        export GIT_WORK_TREE=/srv/foobar.com
        export GIT_DIR=/srv/foobar.com/.git
        cd $GIT_WORK_TREE

        #   Deploy "master" branch.
        #   Note : this instance is not meant to be modified by any other means,
        #   so if I understand correctly, the usual concerns are not affecting this case.
        #   See http://stackoverflow.com/q/12265729 and http://stackoverflow.com/a/28262104
        echo "Execute : git checkout -f master" >> $LOG_FILE
        git checkout -f master &>> $LOG_FILE
        echo "Execute : git reset --hard" >> $LOG_FILE
        git reset --hard &>> $LOG_FILE

        #   Remove untracked files and dirs.
        #   (but keep what is gitignored)
        echo "Execute : git clean -df" >> $LOG_FILE
        git clean -df &>> $LOG_FILE

        #   In case git added new files or dirs, we may have to reset their permissions.
        #   (owner should already be www-paul, so chmod should be allowed)
        #   Note : "chown www-paul:www-data /srv/foobar.com -R" is not possible here,
        #   so in current example, we might have to add "www-data" to group "www-paul".
        find /srv/foobar.com/.git -type f -exec chmod 600 {} +
        find /srv/foobar.com/.git -type d -exec chmod 700 {} +
        find /srv/foobar.com -type f -exec chmod 640 {} +
        find /srv/foobar.com -type d -exec chmod 750 {} +
        #find /srv/foobar.com -type f -wholename "*path/to/writeable/sub/dir*" -exec chmod 660 {} +
        #find /srv/foobar.com -type d -wholename "*path/to/writeable/sub/dir*" -exec chmod 770 {} +

        #   <Insert additional deploy steps here>
        #   ex: drush updb -y

        #   Closing log
        DATE_TIME=$(date +"%F %H:%M:%S")
        echo "\n${DATE_TIME} : Finished Deploy" >> $LOG_FILE

        #   Latest copy
        yes | cp $LOG_FILE $LOG_LATEST_COPY
    fi
done

' > /srv/foobar.com/.git/hooks/post-receive

#   Needs execution permission
chmod +x /srv/foobar.com/.git/hooks/post-receive



#------------------------------------------------------------------------------
#   3. Local : "git remote add" distant server repo & test


#   On local machine :
#   Add distant server repo as an additional remote.
git remote add staging ssh://www-paul@12.34.56.78/srv/foobar.com/.git

#   Test ok 2015/07/19 10:33:00
git push -u staging master

