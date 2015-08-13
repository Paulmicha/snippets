#!/bin/bash
# -*- coding: UTF8 -*-

##
#   Git script :
#   Merge $BRANCH_TO_MERGE in $BRANCH after pull.
#   (from local working repo to $REMOTE)
#   
#   If $PULL_REMOTE is not empty, $BRANCH will be pulled from it before merging.
#   In that case, any conflict will be listed,
#   and neither merge nor push operations will be executed.
#   
#   Install :
#   (as root or sudo)
#   $ wget https://github.com/Paulmicha/snippets/raw/master/Git/Merge.script.sh --quiet -O /usr/local/bin/gm
#   $ chmod +x /usr/local/bin/gm
#   
#   Use :
#   (from working repo dir)
#   
#   Ex.1 : will prompt for $BRANCH_TO_MERGE and $BRANCH, then pull $BRANCH from default remote 'origin' before merging.
#   $ gm
#   
#   Ex.2 : will pull 'develop' from default remote 'origin' before merging 'features/123' in 'develop'.
#   $ gm features/123 develop
#   
#   Ex.3 : will pull 'develop' from 'myserv/staging' before merging 'features/123' in 'develop'.
#   $ gm features/123 develop myserv/staging
#   
#   Sources :
#   Get conflicted files = http://stackoverflow.com/a/11014518/2592338
#   

#   Arg 1 : branch to merge
BRANCH_TO_MERGE=$1
if [[ -z $1 ]]; then
    echo -n "Enter BRANCH_TO_MERGE : "
    read BRANCH_TO_MERGE
fi

#   Arg 2 : in which branch to merge
BRANCH=$2
if [[ -z $2 ]]; then
    echo -n "Enter in which BRANCH to merge ${BRANCH_TO_MERGE} : "
    read BRANCH
fi

#   [optional] Arg 3 : the remote from which $BRANCH will be pulled.
#   (default : origin)
PULL_REMOTE='origin'
if [[ ! -z $3 ]]; then
    PULL_REMOTE=$3
    echo -e "Option detected : ${BRANCH} will be pulled from ${PULL_REMOTE} before merging."
else
    echo -e "${BRANCH} will be pulled from default ${PULL_REMOTE} before merging."
fi


#---------
#   Action

git checkout $BRANCH
git pull $PULL_REMOTE $BRANCH

#   Don't merge if there's any conflict.
CONFLICTS=$(git ls-files --unmerged)
if [[ -z $CONFLICTS ]]; then
    git merge $BRANCH_TO_MERGE -m "Merge $BRANCH_TO_MERGE in $BRANCH"
else
    echo "Error : the following files are conflicted - merge aborted."
    echo $CONFLICTS
    exit 1
fi
