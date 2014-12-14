#!/bin/bash
# -*- coding: UTF8 -*-

##
#   Unix Permissions Basics & snippets
#   (Command-line / Shell / Bash)
#   
#   Should apply to most modern Linux distros
#   Tested on Debian (5, 6, 7) & Ubuntu (12, 14)
#   
#   Sources :
#   http://www.tldp.org/LDP/abs/html/invoking.html
#   http://www.yolinux.com/TUTORIALS/LinuxTutorialManagingGroups.html
#   https://www.digitalocean.com/community/tutorials/linux-permissions-basics-and-how-to-use-umask-on-a-vps
#   http://giantdorks.org/alain/make-ls-output-date-in-long-iso-format-instead-of-short-month/
#   http://ao2.it/wiki/How_to_setup_a_GIT_server_with_gitolite_and_gitweb
#   


#----------------------------------------------------------------------------------------
#       Snippets


#       chmod Examples :
#       Give everyone read/execute permission
chmod 555 path/to/file_or_folder
chmod +rx path/to/file_or_folder
#       Give just the script owner read/execute permission
chmod u+rx path/to/file_or_folder
#       Remove all permissions for "others" (= everyone NOT owner & NOT in group),
#       recursively (= in this folder and all its subfolders).
chmod o-rwx . -R

#       chown Example :
#       Make all files and folders in current dir (including itself) + subdirs owned by user "kevin" & group "kevin"
chown kevin:kevin . -R
#       Same, but using numerical user ID :
chown 1001:1001 . -R

#       Execute for all files in current dir & subdirs
find . -type f -exec chmod 640 {} +

#       Restrict by path (matching by pattern)
find . -type f -wholename "*sites/default/files*" -exec chmod 660 {} +

#       Execute for all dirs in current dir & subdirs
find . -type d -exec chmod 750 {} +



#----------------------------------------------------------------------------------------
#       Disambiguation


#       User name :
#           • human-readable name of a Linux user
#           • "machine" name of a Linux user (usually, a lowercase version of the human-readable name), also = user login
#       User ID :
#           • the user login (usually lowercase user name - see above)
#           • unique numerical reference to the user - examples :
#               root = 0, web server user (www-data) = 33, and other uers are usually assigned numbers > 1000
#       Group ID = numerical user ID



#----------------------------------------------------------------------------------------
#       Explanations


#       On Linux, here are a few basic facts to understand the rest :
#       1. Each file is owned by exactly one user and one group.
#       2. Users may belong to several groups, and are automatically assigned a User Private Group (UPG),
#           which is a unique group of the same name as the user.
#       3. Configuring services/programs to operate AS a distinct user allows to control their permissions.
#       4. Default ownership and permissions are "passively" set upon creation (see below).
#       5. Permission to read a directory also requires execution permission.
#       6. Ownership and permissions cannot be changed on files or folders not owned by the current user,
#       except for the admin user "root".

#       Notations :
#       Description = Abreviation = Octal Code
Read                        = r     = 4
Write                       = w     = 2
Execute                     = x     = 1

#       Combinations (= additions) :
Read and Execute            = rx    = 5
Read and Write              = rw    = 6
Read, Write and Execute     = rwx   = 7



#----------------------------------------------------------------------------------------
#       Default permissions and ownership


#       Let's say "paul" is the current user.
#       By default, for example :
touch test.txt
mkdir test
ls -lah
#       Will result in :
#           -rw-rw-r-- 1 paul paul    0 Dec 14 19:17 test.txt
#           drwxrwxr-x 2 paul paul 4.0K Dec 14 19:17 test
#       Meaning :
#           Default owner : current user
#           Default group : current UPG
#           Default files perms : 664
#           Default folders perms : 775

#       Worth noting :
#       You can add the www-data user (the usual web server - Apache or Nginx workers' - process owner) to any group,
#       so that web access can be "enabled" with the default ownership.
#       Meaning : no need to chown username:www-data for web projects' files or folders when doing this :
adduser www-data my_project_user_private_group

#       Apparently there are 2 popular ways to change these defaults - "umask" and "acl", but :
#       • umask will only apply to the current shell session
#       • acl requires install + disk remount
#       -> I'll just use my own custom bash scripts when needed.



#----------------------------------------------------------------------------------------
#       Utilities


#       List files and folders with ownership/group/permissions info
ls -lah
#       Display numerical IDs for owners and groups (-n option)
ls -lahn
#       Date ISO :
ls -lah --time-style long-iso
#       Note for same result :
export TIME_STYLE=long-iso
ls -lah

#       List users / groups
#       See also http://www.cyberciti.biz/faq/linux-list-users-command/
cat /etc/passwd

#       List groups of current user
groups
#       List groups
groups user_id

#       Set ownership - chown reference
chown user_id:group_id path/to/file/or/folder [-R]

#       Set permissions - chmod reference
chmod [octal] file/or/directory [-R]

#       Change specific permissions - chmod reference
#       @see http://man.yolinux.com/cgi-bin/man2html?cgi_command=chmod
chmod [ugoa][+-=][rwxXst] file/or/directory [-R]

#       Adding a user to a group
adduser auser agroup


