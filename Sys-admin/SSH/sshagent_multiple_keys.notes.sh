#!/bin/bash
# -*- coding: UTF8 -*-

##
# Bash notes : using multiple keys with sshagent.
#
# Sources :
# https://superuser.com/questions/272465/using-multiple-ssh-public-keys/272613#272613
#

# The IdentitiesOnly .ssh/config configuration keyword can be used
# to limit the keys that ssh offers to the remote sshd to just those
# specified via IdentityFile keywords (i.e. it will refuse to use
# any additional keys that happen to be loaded into an active ssh-agent).

# Try these .ssh/config sections:

Host {personalaccount}.unfuddle.com
     IdentityFile ~/.ssh/id_rsa
     IdentitiesOnly yes

Host {companyaccount}.unfuddle.com
     IdentityFile ~/.ssh/{companyaccount}_rsa
     IdentitiesOnly yes

# Then, use Git URLs like these:

git@{personalaccount}.unfuddle.com:{personalaccount}/my-stuff.git
git@{companyaccount}.unfuddle.com:{companyaccount}/their-stuff.git


# If you want to take full advantage of the .ssh/config mechanism,
# you can supply your own custom hostname and change the default user name:

Host uf-mine
     HostName {personalaccount}.unfuddle.com
     User git
     IdentityFile ~/.ssh/id_rsa
     IdentitiesOnly yes

Host uf-comp
     HostName {companyaccount}.unfuddle.com
     User git
     IdentityFile ~/.ssh/{companyaccount}_rsa
     IdentitiesOnly yes


# Then, use Git URLs like these:

uf-mine:{personalaccount}/my-stuff.git
uf-comp:{companyaccount}/their-stuff.git
