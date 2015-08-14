#!/bin/bash
# -*- coding: UTF8 -*-

##
#   Git snippets : Patch-related operations
#   
#   Sources :
#   Create patch from uncommitted changes = http://stackoverflow.com/a/15438863/2592338
#   Create patch from commit :
#       http://stackoverflow.com/questions/6658313/generate-a-git-patch-for-a-specific-commit
#       http://stackoverflow.com/questions/9396240/how-do-i-simply-create-a-patch-from-my-latest-git-commit
#   

#------------------------------------------------------------------------------
#   Create Patch of committed changes

#   Latest commit
git format-patch -1 HEAD --stdout > patchfile.patch

#   Any single commit
git format-patch -1 dffbd117 --stdout > patchfile.patch

#   Every commits since commit dffbd117
git format-patch dffbd117


#------------------------------------------------------------------------------
#   Create Patch of uncommitted changes

git diff > patchfile.patch


#------------------------------------------------------------------------------
#   Apply patch

patch -p1 < patchfile.patch
