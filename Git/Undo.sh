#!/bin/bash
# -*- coding: UTF8 -*-

##
#   Git snippets : Undo
#   
#   Sources :
#   http://stackoverflow.com/questions/953481/find-and-restore-a-deleted-file-in-a-git-repo
#   http://superuser.com/questions/229290/how-to-amend-the-last-commit-to-un-add-a-file
#   

#   Restore file
F='path/to/file'
git checkout $(git rev-list -n 1 HEAD -- $F)^ -- $F

#   Undo added files to last commit (not pushed yet).
git reset HEAD^ path/to/accidentally/added/stuff
git commit --amend
