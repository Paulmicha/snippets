#!/bin/bash
# -*- coding: UTF8 -*-

##
#   Filesystem basics snippets
#   Mainly CRUD, Search, Replace
#   (Command-line / Shell / Bash)
#   
#   Should apply to most modern Linux distros
#   Tested on Debian (5, 6, 7) & Ubuntu (12, 14)
#   
#   Sources :
#   http://stackoverflow.com/questions/5070545/php-read-file-contents-of-network-share-file
#   http://craig.mayhew.io/blog/2010/12/mounting-a-windows-share-on-linux/
#   http://giantdorks.org/alain/make-ls-output-date-in-long-iso-format-instead-of-short-month/
#   


#---------------------------------------------------------------------------
#       CRUD


#       Create folder
mkdir /path/to/folder

#       Create folder "recursively" (auto creating any missing "intermediate" parent folders)
mkdir --parent /path/to/folder

#       Create file
touch path/to/filename.ext
#       Create file with content
echo "File content" > path/to/filename.ext

#       Create file with long content.
cat > path/to/filename.ext <<'EOF'
Any character here will be written to path/to/filename.ext
No need to escape any quotes like ' or ".
$VAR won't be interpreted, because 'EOF' above is quoted.
EOF

#       Create file with long content - with variables support.
cat > path/to/filename.ext <<EOF
Any character here will be written to path/to/filename.ext
No need to escape any quotes like ' or ".
$VAR will be interpreted, because EOF above is NOT quoted.
EOF

#       List files and folders with ownership/group/permissions info
ls -lah
#       Date ISO :
ls -lah --time-style long-iso
#       Note for same result :
export TIME_STYLE=long-iso
ls -lah

#       Read / edit
nano /path/to/file.ext

#       Read end of file contents (last n lines)
#       NB: replace 10 below for desired nb of lines to display
tail /path/to/file.ext -n10

#       Append content to existing file
#       (auto newline before)
echo "File content" >> path/to/filename.ext

#       Delete file
rm path/to/filename.ext
#       Delete file w/o confirmation prompt
rm path/to/filename.ext --force

#       Delete folder (recursively)
rm path/to/folder -r
#       Delete folder (recursively) w/o confirmation prompt
rm path/to/folder -r --force



#---------------------------------------------------------------------------
#       Search


#       Look for text in files
#       NB: "example" is regex
find /path/to/folder -type f -exec grep "example" {} +

#       Match whole word
grep "^\W*example" path/to/file | tr -s " "

#       List matching folders (with slash)
find . -type d -wholename "*my/path/to*"

#       List *.jpg files (recursively)
find . -name "*.jpg"

#       Delete "found" files
find . -depth -type f -name "*.jpg" -exec rm -f {} +

#       List folders named 'images' (recursively)
find . -type d -name "*\images"

#       Delete "found" folders
find . -depth -type d -name "*\images" -exec rm -rf {} +



#---------------------------------------------------------------------------
#       Replace


#       Search / replace (regex) inside a file
#       -> "example" will be replaced by "foobar"
sed -e 's,example,foobar,g' -i /path/to/filename

#       Idem, but creating a backup filename.bak before modifying the file
#       (notice the param "-i.bak")
sed -e 's,example,foobar,g' -i.bak /path/to/filename



#---------------------------------------------------------------------------
#       Mount


#       Mounting local (LAN) shared filesystem in Linux
#       @see http://stackoverflow.com/questions/5070545/php-read-file-contents-of-network-share-file
#       @see http://craig.mayhew.io/blog/2010/12/mounting-a-windows-share-on-linux/
mount -t cifs //192.168.xxx.xxx/path/to/share /path/to/dirtomount -o user=USERNAME,password=PASSWORD


