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

#the file into which the return code will be written
RETURN_FILE="$1"


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
export ANSIBLE_ANY_ERRORS_FATAL=True
cd $ScriptDirectory/../playbooks
if [ -n "$USERPASS" ]; then
	echo "$(date) Install and set up OpenLDAP (see deployment-openldap.log)"

	time ansible-playbook -v -f $FORKS "${CODE_DIRECTORY}/openldap/openldapsetup.yml" -i $INVENTORY_FILE -e "OLCROOTPW='$ADMINPASS' OLCUSERPW='$USERPASS'"
	ret="$?"
	if [ "$ret" -ne "0" ]; then
		exit $ret
	fi
#	rm -f "${ORCHESTRATION_DIRECTORY}/sas_viya_playbook/roles/consul/files/sitedefault.yml"
#	cp "${CODE_DIRECTORY}/openldap/sitedefault.yml" "${ORCHESTRATION_DIRECTORY}/sas_viya_playbook/roles/consul/files/"
fi
time ansible-playbook -f $FORKS -i $INVENTORY_FILE -v at.deployment.yml -e VIRK_CLONE_DIRECTORY="$VIRK_CLONE_DIRECTORY" -e ORCHESTRATION_DIRECTORY="$ORCHESTRATION_DIRECTORY" -e "sasboot_pw='$ADMINPASS'" -e "OLCROOTPW='$ADMINPASS' OLCUSERPW='$USERPASS'" -e LOCAL_DIRECTORY_MIRROR="${DIRECTORY_MIRROR}" -e REMOTE_DIRECTORY_MIRROR="${REMOTE_DIRECTORY_MIRROR}" -e MIRROR_HTTP="${MIRROR_HTTP}" -e LICENSE_FILE="${FILE_LICENSE_FILE}" -e SSL_WORKING_FOLDER="${DIRECTORY_SSL_JSON_FILE}" -e CODE_DIRECTORY="${CODE_DIRECTORY}"
ret="$?"
if [ "$ret" -ne "0" ]; then
    exit $ret
fi

if [ -n "$USERPASS" ]; then
    rm -f "${ORCHESTRATION_DIRECTORY}/sas_viya_playbook/roles/consul/files/sitedefault.yml"
	cp "${CODE_DIRECTORY}/openldap/sitedefault.yml" "${ORCHESTRATION_DIRECTORY}/sas_viya_playbook/roles/consul/files/"
fi

time ansible-playbook -v -f $FORKS "${VIRK_CLONE_DIRECTORY}/playbooks/pre-install-playbook/viya_pre_install_playbook.yml" -i "$ORCHESTRATION_DIRECTORY/sas_viya_playbook/inventory.ini" --skip-tags skipmemfail,skipcoresfail,skipstoragefail,skipnicssfail,bandwidth -e 'use_pause=false'
ret="$?"
if [ "$ret" -ne "0" ]; then
    exit $ret
fi


sudo chown -R $USER "${ORCHESTRATION_DIRECTORY}"
cd "${ORCHESTRATION_DIRECTORY}/sas_viya_playbook"
ansible-playbook -v site.yml
ret="$?"
if [ ! -z "$RETURN_FILE" ]; then
    echo "$ret" > "$RETURN_FILE"
fi
if [ "$ret" -ne "0" ]; then
    exit $ret
fi
