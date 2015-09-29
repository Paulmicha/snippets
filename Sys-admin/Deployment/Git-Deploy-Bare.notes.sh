#!/bin/bash
# -*- coding: UTF8 -*-

##
#   Deployment notes :
#   Git deploy using bash + bare Git repo.
#   
#   Goal :
#   Automatically deploy project to remote server(s) after pushing.
#   
#   Prerequisites :
#   • Existing project versionned in git - privately hosted or on Bitbucket, Github, etc.
#   • Local project instance (working repo)
#   • SSH-accessible server to host the project's instance to deploy to (and the remote bare repo)
#   
#   Steps :
#   1. Setup SSH connection & check permissions
#   2. Remote : create bare repo
#   3. Remote : implement post-receive hook
#   4. Local : "git remote add" distant server repo & test
#   
#   Usage example :
#   Supposing remote repo is added under the name 'remote-server/staging',
#   and 'develop' is the desired branch :
#   • Local : git push -u remote-server/staging develop
#   
#   Warnings :
#   • Security : use these notes at your own risk (permissions depend on many other factors).
#   • Because of "git clean -df" in post-receive example script, ".gitignore" should be properly configured.
#
#   Tested on :
#   Debian 8 "Jessie" (local)
#   Ubuntu 14.04 LTS "Trusty" (remote)
#   
#   @timestamp 2015/08/05 05:36:55
#   
#   Sources :
#   http://stackoverflow.com/questions/3207728/retaining-file-permissions-with-git
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
#   it is assumed that for the project hosted on the remote server,
#   a corresponding dedicated unix user exists, and owns all files and dirs.
#   From here on, the following example values (to adapt) will be used :
#       • Project : staging.foobar.com
#       • Remote server : 12.34.56.78
#       • Remote server unix user : www-paul
#       • Remote bare repo dir : ~/staging.foobar.com.git
#       • Remote project (deploy) dir : /var/www/staging.foobar.com/docroot
#       • Git user : Paulmicha
#       • Git origin (default remote) : Bitbucket
#       • Git remote name : remote-server/staging


#---------------------
#   On remote server :

#   Connect as www-paul.
ssh www-paul@12.34.56.78

#   Check that "~/.ssh" dir exists, if not, create it.
if ! [ -d "$HOME/.ssh" ] ; then
    mkdir "$HOME/.ssh"
fi


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

#   Verify SSH agent is running, if not, launch it.
#   Note : if a passphrase was used to generate the key, "ssh-add" will prompt for it.
if [ -z "$SSH_AUTH_SOCK" ] ; then
    eval `ssh-agent -s`
    ssh-add
fi

#   Send public key to remote server www-paul's "authorized_keys" file.
ssh-copy-id www-paul@12.34.56.78

#   Test passwordless SSH connection
#   (should not prompt for password)
ssh www-paul@12.34.56.78



#------------------------------------------------------------------------------
#   2. Remote : create bare repo

#   Connect as www-paul.
ssh www-paul@12.34.56.78

#   Create bare repo.
git clone --bare git@bitbucket.org:Paulmicha/foobar.com.git ~/staging.foobar.com.git



#------------------------------------------------------------------------------
#   3. Remote : post-receive hook


#   On remote server, as www-paul :
#   Create the (bash) script to be executed on post-receive.
#   The following script is to be adapted for current project's needs.
cat > ~/staging.foobar.com.git/hooks/post-receive <<'EOF'
#!/bin/bash
# -*- coding: UTF8 -*-

#   Deploy settings.
INSTANCE="staging.foobar.com"
BRANCH_TO_DEPLOY="develop"
DEPLOY_DIR="/var/www/$INSTANCE/docroot"

#   Manual lock :
#   prevent potentail concurrent deployments.
LOCK="$HOME/.deploying-$INSTANCE.lock"
if [ -f $LOCK ]; then
    echo "Error : existing lock found."
    echo "A previous deployment may still be in progress."
    exit 1
fi
touch $LOCK

#   Get post-receive arguments.
#   @param oldrev : previous commit SHA1 hash
#   @param newrev : last commit SHA1 hash
#   @param refname : branch information (ex: "refs/heads/develop")
#   Note : the 'while' is needed in case there are several branches pushed at once.
while read oldrev newrev refname
do
    branch=$(git rev-parse --symbolic --abbrev-ref $refname)
    if [ $branch==$BRANCH_TO_DEPLOY ]; then

        #   Optional : "manual" logging.
        #   Warning : deploy user (www-paul) MUST be allowed to `mkdir -p $LOG_DIR`,
        #   as there is currently no check in the example below.
        DATE_TIME=$(date +"%F %H:%M:%S")
        LOG_DIR="$HOME/log/$INSTANCE/$(date +%Y)/$(date +%m)/$(date +%d)"
        LOG_FILE="${LOG_DIR}/$(date +%H)-$(date +%M)-$(date +%S)-${newrev:0:8}.log"
        LOG_FILE_LAST="$HOME/log/$INSTANCE/last_post_receive.log"
        if [ ! -d $LOG_DIR ]; then
            mkdir -p $LOG_DIR
        fi

        #   Logging.
        echo -e "${DATE_TIME} : Received Push Request" >> $LOG_FILE
        echo -e "Old SHA: ${oldrev}\nNew SHA: ${newrev}\nBranch Name: ${refname}\n" >> $LOG_FILE
        
        #   Optional : DB dump backup.
        DUMP_DIR="$HOME/dump/$INSTANCE/$(date +%Y)/$(date +%m)/$(date +%d)"
        DUMP_FILE="${DUMP_DIR}/$(date +%H)-$(date +%M)-$(date +%S)-${newrev:0:8}.sql"
        DUMP_FILE_LAST="$HOME/dump/$INSTANCE/last.sql.gz"
        if [ ! -d $DUMP_DIR ]; then
            mkdir -p $DUMP_DIR
        fi

        #   Logging.
        echo "DB Backup - Execute : drush sql-dump --gzip --root=$DEPLOY_DIR --result-file=$DUMP_FILE --structure-tables-list='cache,cache_block,cache_filter,cache_form,cache_menu,cache_page,history,watchdog'" >> $LOG_FILE

        #   Optional : Drupal DB dump.
        drush sql-dump --gzip --root=$DEPLOY_DIR --result-file=$DUMP_FILE --structure-tables-list="cache,cache_block,cache_filter,cache_form,cache_menu,cache_page,history,watchdog" &>> $LOG_FILE
        cp -f "$DUMP_FILE.gz" $DUMP_FILE_LAST
        
        #   Logging.
        echo "Execute : git checkout -f $BRANCH_TO_DEPLOY" >> $LOG_FILE

        #   Update sources with git checkout.
        export GIT_WORK_TREE=$DEPLOY_DIR
        git checkout -f $BRANCH_TO_DEPLOY &>> $LOG_FILE

        #   Logging.
        echo "Execute : git clean -df" >> $LOG_FILE

        #   Remove untracked files and dirs.
        #   (but keep what is gitignored)
        git clean -df &>> $LOG_FILE

        #   Logging.
        echo "Restoring permissions." >> $LOG_FILE

        #   Permission / security notes :
        #   • Git stores only executable bit (for ordinary files) and symlink bit.
        #   • The following setup is tested in a basic LAMP stack setup (mod_php),
        #       and is indicated for reference only (alternatives : setbit, umask, acl).
        #   → Checked out project sources ownership :
        #       www-paul:www-paul (all files & dirs in /var/www/staging.foobar.com/docroot)
        #       + user www-data added to www-paul group (in php-fmp / fcgi setup, see process ownership).
        #   → Optional : apply checked out sources permissions after every deploy.
        find $DEPLOY_DIR -type f -exec chmod 0640 {} + &>> $LOG_FILE
        find $DEPLOY_DIR -type d -exec chmod 0750 {} + &>> $LOG_FILE
        find $DEPLOY_DIR -type f -wholename "$DEPLOY_DIR/path/to/writeable/dir*" -exec chmod 0660 {} + &>> $LOG_FILE
        find $DEPLOY_DIR -type d -wholename "$DEPLOY_DIR/path/to/writeable/dir*" -exec chmod 0770 {} + &>> $LOG_FILE

        #   Logging.
        echo "Launching Drupal updates." >> $LOG_FILE

        #   <Insert additional deploy steps here>
        #   Example : Drupal updates.
        drush updb -y --root=$DEPLOY_DIR &>> $LOG_FILE

        #   Logging.
        DATE_TIME=$(date +"%F %H:%M:%S")
        echo -e "\n${DATE_TIME} : Finished Deploy" >> $LOG_FILE
        cp -f $LOG_FILE $LOG_FILE_LAST
    fi
done

#   Release manual lock.
rm $LOCK

EOF

#   Needs execution permission
chmod 0700 ~/staging.foobar.com.git/hooks/post-receive



#------------------------------------------------------------------------------
#   4. Local : "git remote add" distant server repo & test


#   On local machine :
#   Add distant server repo as an additional remote.
git remote add remote-server/staging ssh://www-paul@12.34.56.78/home/www-paul/staging.foobar.com.git

#   Test deploy.
git push -u remote-server/staging develop

