#!/bin/bash
# -*- coding: UTF8 -*-

##
#   Git snippet
#   Remove all locally deleted files at once
#   
#   Sources :
#   http://stackoverflow.com/questions/492558/removing-multiple-files-from-a-git-repo-that-have-already-been-deleted-from-disk
#   

git rm $(git ls-files --deleted)
