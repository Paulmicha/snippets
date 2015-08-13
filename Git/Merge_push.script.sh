#!/bin/bash
# -*- coding: UTF8 -*-

##
#   Git script :
#   Merge $BRANCH_TO_MERGE in $BRANCH and push.
#   (from local working repo to $REMOTE)
#   
#   If $PULL_REMOTE is not empty, $BRANCH will be pulled from it before merging.
#   In that case, any conflict will be listed,
#   and neither merge nor push operations will be executed.
#   
#   Install (as root/sudo) :
#   $ wget https://github.com/Paulmicha/snippets/raw/master/Git/Merge_push.script.sh --quiet -O /usr/local/bin/gmp
#   $ chmod +x /usr/local/bin/gmp
#   
#   Use (from working repo dir) :
#   Ex.1 : will prompt for $BRANCH_TO_MERGE and $BRANCH then push $BRANCH to default remote 'origin'.
#   $ gmp
#   
#   Ex.2 : will merge 'features/123' in 'develop', then push 'develop' to default remote 'origin'.
#   $ gmp features/123 develop
#   
#   Ex.3 : will pull 'develop' from 'origin' before merging 'features/123' in 'develop', then push 'develop' to default remote 'origin'.
#   $ gmp features/123 develop origin
#   
#   Ex.4 : will pull 'develop' from 'origin' before merging 'features/123' in 'develop', then push 'develop' to remote 'myserv/staging'.
#   $ gmp features/123 develop origin myserv/staging
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

#   [optional] Arg 3 : If $PULL_REMOTE is not empty, $BRANCH will be pulled from it before merging.
#   (default : empty)
if [[ ! -z $3 ]]; then
    PULL_REMOTE=$3
    echo -e "Option detected : ${BRANCH} will be pulled from ${PULL_REMOTE} before merging."
fi

#   [optional] Arg 4 : the remote to push to.
#   (default : 'origin')
REMOTE='origin'
if [[ ! -z $4 ]]; then
    echo -e "Option detected : ${REMOTE} will be pushed to."
    REMOTE=$4
else
    echo -e "Default remote ${REMOTE} will be pushed to."
fi


#---------
#   Action

git checkout $BRANCH

#   Optional : check pull "request".
if [[ ! -z $PULL_REMOTE ]]; then
    git pull $PULL_REMOTE $BRANCH
fi

#   Don't merge if there's any conflict.
CONFLICTS=$(git ls-files --unmerged)
if [[ -z $CONFLICTS ]]; then
    git merge $BRANCH_TO_MERGE -m "Merge $BRANCH_TO_MERGE in $BRANCH"
    git push -u $REMOTE $BRANCH
else
    echo "Error : the following files are conflicted - merge aborted."
    echo $CONFLICTS
    exit 1
fi
