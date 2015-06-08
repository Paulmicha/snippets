#!/bin/bash
# -*- coding: UTF8 -*-

##
#   Git snippets :
#   Started making changes in wrong branch !
#   
#   Sources :
#   http://firstaidgit.io/#/
#   http://stackoverflow.com/questions/1398329/take-all-my-changes-on-the-current-branch-and-move-them-to-a-new-branch-in-git
#   

#   Bring modifications from current branch into a new one.
#   (Note : this will not remove changes on current branch)
git checkout -b my-new-branch-name

#   If the branch already exists, use git stash wrapper
#   for moving uncommitted changes.
git stash
git checkout branch-i-wanted-to-work-on
git stash apply

#   If you have already started to make a few commits,
#   see http://stackoverflow.com/questions/1398329/take-all-my-changes-on-the-current-branch-and-move-them-to-a-new-branch-in-git
git stash
git checkout -b branch-i-wanted-to-work-on wrong-branch
git branch -f wrong-branch SHA1_before_your_commits
git stash apply
