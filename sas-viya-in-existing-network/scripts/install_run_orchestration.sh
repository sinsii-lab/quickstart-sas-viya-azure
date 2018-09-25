#!/bin/bash
if [ -e "$HOME/.profile" ]; then
	. $HOME/.profile
fi
if [ -e "$HOME/.bash_profile" ]; then
	. $HOME/.bash_profile
fi
#set -x
#set -v
ScriptDirectory="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

FORKS=5

INVENTORY_FILE="inventory.ini"

# sometimes there are ssh connection errors (53) during the install
# this function allows to retry N times
function try () {
  # allow up to N attempts of a command
  # syntax: try N [command]
  RC=1; count=1; max_count=$1; shift
  until  [ $count -gt "$max_count" ]
  do
    "$@" && RC=0 && break || let count=count+1
  done
  return $RC
}

export ANSIBLE_STDOUT_CALLBACK=debug

sudo chown -R $USER "${ORCHESTRATION_DIRECTORY}"
cd "${ORCHESTRATION_DIRECTORY}/sas_viya_playbook"
ansible-playbook -v site.yml
ret="$?"
if [ "$ret" -ne "0" ]; then
    exit $ret
fi

