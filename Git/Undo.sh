#!/bin/bash
# -*- coding: UTF8 -*-

##
#   Git snippets : Undo
#   
#   Sources :
#   http://stackoverflow.com/questions/953481/find-and-restore-a-deleted-file-in-a-git-repo
#   

#   Restore file
F='path/to/file'
git checkout $(git rev-list -n 1 HEAD -- $F)^ -- $F
