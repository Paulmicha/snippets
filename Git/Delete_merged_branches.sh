#!/bin/bash
# -*- coding: UTF8 -*-

##
#   Git snippets :
#   Delete branches that are already merged
#   
#   Sources :
#   http://stevenharman.net/git-clean-delete-already-merged-branches
#   http://stackoverflow.com/questions/6127328/how-can-i-delete-all-git-branches-which-have-been-merged
#   

#   Delete all branches that are already merged into the current branch
#   Warning : also deletes local-only branches
git branch --merged | grep -v "\*" | xargs -n 1 git branch -d

#   Delete all branches that are already merged into, for example, branch 'ANY-BRANCH'
git branch --merged ANY-BRANCH | grep -v "\* ANY-BRANCH" | xargs -n 1 git branch -d
