#!/bin/bash
# -*- coding: UTF8 -*-

##
#   Git snippets :
#   Delete branch
#   
#   Sources :
#   http://makandracards.com/makandra/621-git-delete-a-branch-local-or-remote
#   

#   Delete local branch
git branch -d the_local_branch

#   Delete remote branch
git push origin :the_remote_branch

#   Fetch deleted branches
#   (prune : remove any remote-tracking branches which no longer exist on the remote)
#   update 2015/09/21 16:05:36 - seems NOK
#   (test : running "git branch" in the local working dir displays deleted remote branches)
#git fetch -p
