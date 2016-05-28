#!/bin/bash
# -*- coding: UTF8 -*-

##
#   Bash script : autostart sshagent.
#
#   Sources :
#   Start ssh-agent on login - http://stackoverflow.com/a/18915067/2592338
#

cat >> "$HOME/.bash_profile" <<'EOT'

#  Auto-start SSH agent on login
#  @see http://stackoverflow.com/a/18915067/2592338
SSH_ENV="$HOME/.ssh/environment"
function start_agent {
    echo "Initialising new SSH agent..."
    /usr/bin/ssh-agent | sed 's/^echo/#echo/' > "${SSH_ENV}"
    echo succeeded
    chmod 600 "${SSH_ENV}"
    . "${SSH_ENV}" > /dev/null
    /usr/bin/ssh-add;
}
if [ -f "${SSH_ENV}" ]; then
    . "${SSH_ENV}" > /dev/null
    ps -ef | grep ${SSH_AGENT_PID} | grep ssh-agent$ > /dev/null || {
        start_agent;
    }
else
    start_agent;
fi

EOT
