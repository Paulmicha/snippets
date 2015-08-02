#!/bin/bash
# -*- coding: UTF8 -*-

##
#   Bash basics : notes on line endings encoding conversion.
#   
#   Sources :
#   https://help.github.com/articles/dealing-with-line-endings/
#   http://stackoverflow.com/a/20653073/2592338
#   http://www.unixcl.com/2008/04/linux-flip-command-alternative-of.html
#   http://editorconfig.org/
#   

# -----------------------------------------------------------------------------
#   Ensure Unix-style newlines
#   + for Git : both locally and in the repo.

#   Install
apt-get install flip -y

#   Convert line endings from Windows/DOS (CRLF) to Unix (LF).
flip -u path/to/file.txt

#   Batch convert (recursively for all files in current folder) :
find . -type f -exec flip -u {} +

#   Git config
git config core.autocrlf false
