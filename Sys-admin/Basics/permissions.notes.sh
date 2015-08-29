#!/bin/bash
# -*- coding: UTF8 -*-

##
#   Unix Permissions Basics & snippets
#   (Command-line / Shell / Bash)
#   
#   Applies to modern Linux distros.
#   
#   Sources :
#   http://permissions-calculator.org/
#   http://ss64.com/bash/syntax-permissions.html
#   http://www.techrepublic.com/blog/it-security/understand-the-setuid-and-setgid-permissions-to-improve-security/
#   http://superuser.com/questions/381416/forcing-group-and-permissions-for-created-file-inside-folder
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
#       3. Configuring services/programs to operate AS a distinct user allows to control their permissions,
#           although SetUID may alter this behavior, see 7.
#       4. Default ownership and permissions are "passively" set upon creation (see below).
#       5. Permission to read a directory also requires execution permission.
#       6. Ownership and permissions cannot be changed on files or folders not owned by the current user,
#           except for the admin user "root".
#
#       Advanced behaviors :
#       7. SetUID and SetGID are special permission bits allowing any user to execute a file or script with
#           the permissions of its owner or group. Thus, enabling those can easily create security breaches.
#           When used on directories, SetUID is ignored, but SetGID make all newly created files and subdirs
#           in these folders inherit the parent directory's owner and/or group, instead of the current user's.
#           Group must have execute rights for setgid to work.
#           User must have execute rights for setuid to work.
#           In cases where it has no effect it is represented with an upper-case "S".
#       8. The sticky bit is a user ownership access right flag that Linux ignores on files, but on a directory,
#           files in that directory may only be removed or renamed by root or the directory owner or the file owner.
#           Typically this is set on the /tmp directory to prevent ordinary users from deleting or moving other users' files.
#           All public directories should be configured with sticky bit.
#           Other (everyone) must have execute rights for sticky bit to work.
#           In cases where it has no effect it is represented with an upper-case "T".

#       Notations :
#       Description = Abreviation = Octal Code
None                                = 0
Read                        = r     = 4
Write                       = w     = 2
Execute                     = x     = 1

#       Combinations (= additions) :
Read and Execute            = rx    = 5
Read and Write              = rw    = 6
Read, Write and Execute     = rwx   = 7

#       Special bits : sticky, setuid, setgid :
None                                = 0
Sticky                      = t     = 1
SetUID                      = s     = 2
SetGID                      = s     = 4

#       Special bits combinations (= additions) :
Sticky and SetUID           = t     = 3
Sticky and SetGID           = t     = 5
SetUID and SetGID           = t     = 6
Sticky, SetUID and SetGID   = t     = 7



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
#           Default files perms : 0664
#           Default folders perms : 0775

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

#       Read ownership
stat -c %U:%G /path/to/file/or/folder

#       Set ownership - chown reference
chown user_id:group_id path/to/file/or/folder [-R]

#       Set permissions - chmod reference
chmod [octal] file/or/directory [-R]

#       Change specific permissions - chmod reference
#       @see http://man.yolinux.com/cgi-bin/man2html?cgi_command=chmod
chmod [ugoa][+-=][rwxXst] file/or/directory [-R]

#       Adding a user to a group
adduser auser agroup


