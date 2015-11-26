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
#   Apply diff file = http://stackoverflow.com/questions/12320863/how-do-you-take-a-git-diff-file-and-apply-it-to-a-local-branch-that-is-a-copy-o
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
git diff path/to/file > patchfile.patch


#------------------------------------------------------------------------------
#   Apply patch

patch -p1 < patchfile.patch

#   For diff files (warning : no author info).
git apply file.diff
