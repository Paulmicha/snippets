#!/bin/bash
# -*- coding: UTF8 -*-

##
#   Git snippets :
#   Ignore files and/or paths
#   
#   Sources :
#   http://stackoverflow.com/questions/1818895/keep-ignored-files-out-of-git-status
#   http://stackoverflow.com/questions/1753070/git-ignore-files-only-locally
#   http://stackoverflow.com/questions/13630849/git-difference-between-assume-unchanged-and-skip-worktree/13631525#13631525
#   

#   .gitignore only works for untracked files.
#   If you added files to repository :
#   assumes the files corresponding to that portion of the index have not been modified in the working copy
git update-index --assume-unchanged <file>

#   pretend it has not been modified, using the version from the index instead. This persists until the index is discarded.
git update-index --skip-worktree  <file>

#   or remove them from repository
git rm --cached <file>
