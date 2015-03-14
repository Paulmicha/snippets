#!/bin/bash
# -*- coding: UTF8 -*-

##
#   File Compression related snippets
#   Command-line / Shell / Bash
#   
#   Should apply to most modern Linux distros
#   Tested on Debian (5, 6, 7) & Ubuntu (12, 14)
#   
#   Sources :
#   http://stackoverflow.com/questions/984204/shell-command-to-tar-directory-excluding-certain-files-folders
#   


#---------------------------------------------------------------------------
#       Tar &/ Gzip


#       Create tar/gzip archive
tar czf myfilename.tgz path/to/filename.ext
tar czf mydirname.tgz path/to/folder/

#       Compress excluding a folder
#       Note : no trailing slashes in excluded folders
tar czf --exclude=www/sites/default/files filename.tgz www/

#       Compress excluding multiple folders
#       Note : no trailing slashes in excluded folders
#       @see http://stackoverflow.com/questions/984204/shell-command-to-tar-directory-excluding-certain-files-folders
tar czf --exclude='/path/to/excluded/folder/a' --exclude='/path/to/excluded/folder/b' filename.tgz /path/to/compress/

#       Compress excluding files larger than 1024k
find . -type f -size -1024k | tar -cz -f filename.tgz -T -

#       Decompress (tar/gzip)
tar xzf filename.tgz
tar xzf filename.tgz destination_dir/



#---------------------------------------------------------------------------
#       Unzip


#       Usually not installed by default
#       Ex. install with aptitude (Debian / Ubuntu, as root)
aptitude install unzip -y

#       Decompress (zip)
unzip filename.zip


