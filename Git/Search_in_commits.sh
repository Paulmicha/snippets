#!/bin/bash
# -*- coding: UTF8 -*-

##
#   Git snippets :
#   Search in commits.
#   
#   Sources :
#   http://stackoverflow.com/questions/5816134/finding-a-git-commit-that-introduced-a-string-in-any-branch
#   http://stackoverflow.com/questions/4468361/search-all-of-git-history-for-a-string
#   

#   "git log" parameters :
#   --all = start from every branch
#   --source = show which of those branches led to finding that commit
#   -p = show the patches that each of those commits would introduce
git log -S 'hello world' --source --all

#   -G = regex pattern
#   ex: find occurrences of function foo() {
git log -G "^(\s)*function foo[(][)](\s)*{$" --source --all
