#!/bin/bash
# -*- coding: UTF8 -*-

##
#   Git snippets :
#   View changes (diff) excluding some path or file
#   
#   Sources :
#   http://stackoverflow.com/questions/4380945/exclude-a-directory-from-git-diff
#       → http://stackoverflow.com/a/29374503/2592338
#   

#   Inspect current changes :
git diff -- . ':!path/to/exclude'

#   Inspect changes between certain versions :
git diff previous_release..current_release -- . ':!path/to/exclude'
