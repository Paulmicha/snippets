#!/bin/bash
# -*- coding: UTF8 -*-

##
#   Git snippets :
#   Compare / Diff branches
#   
#   Sources :
#   http://stackoverflow.com/questions/9834689/comparing-two-branches-in-git
#   

#   Compare (or diff) branch_1 and branch_2.
#   Shows what is in branch_2 that is not in branch_1.
git diff branch_1..branch_2
git diff develop..master

#   XOR diff : show what is either in branch_1 or branch_2 but not both.
git diff branch_1...branch_2
git diff develop...master
