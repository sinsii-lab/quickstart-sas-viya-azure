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
cd $ScriptDirectory/../playbooks

INVENTORY_FILE="inventory.ini"
VIRK_CLONE_DIRECTORY="/exports/bastion/setup/virk"
ORCHESTRATION_DIRECTORY="/exports/bastion/setup/orchestration"
CODE_DIRECTORY="/exports/bastion/setup/code"


export ANSIBLE_STDOUT_CALLBACK=debug

time ansible-playbook -i $INVENTORY_FILE -v create_main_inventory.yml 
ret="$?"
if [ "$ret" -ne "0" ]; then
    exit $ret
fi

time ansible-playbook -f $FORKS -i $INVENTORY_FILE -v pre.deployment.yml -e VIRK_CLONE_DIRECTORY="$VIRK_CLONE_DIRECTORY" -e ORCHESTRATION_DIRECTORY="$ORCHESTRATION_DIRECTORY"
ret="$?"
if [ "$ret" -ne "0" ]; then
    exit $ret
fi

time ansible-playbook -f $FORKS -i $INVENTORY_FILE -v update.inventory.yml -e VIRK_CLONE_DIRECTORY="$VIRK_CLONE_DIRECTORY" -e ORCHESTRATION_DIRECTORY="$ORCHESTRATION_DIRECTORY"
ret="$?"
if [ "$ret" -ne "0" ]; then
    exit $ret
fi

time ansible-playbook -v -f $FORKS "${VIRK_CLONE_DIRECTORY}/playbooks/pre-install-playbook/viya_pre_install_playbook.yml" -i "$ORCHESTRATION_DIRECTORY/sas_viya_playbook/inventory.ini" --skip-tags skipmemfail,skipcoresfail,skipstoragefail,skipnicssfail,bandwidth -e 'use_pause=false'
ret="$?"
if [ "$ret" -ne "0" ]; then
    exit $ret
fi

if [ -n "$USERPASS" ]; then
	echo "$(date) Install and set up OpenLDAP (see deployment-openldap.log)"

	time ansible-playbook -v -f $FORKS "${CODE_DIRECTORY}/openldap/openldapsetup.yml" -i $INVENTORY_FILE -e "OLCROOTPW='$ADMINPASS' OLCUSERPW='$USERPASS'"
	ret="$?"
	if [ "$ret" -ne "0" ]; then
		exit $ret 
	fi
	cp "${CODE_DIRECTORY}/openldap/sitedefault.yml" "${ORCHESTRATION_DIRECTORY}/sas_viya_playbook/roles/consul/files/"
fi

time ansible-playbook -f $FORKS -i $INVENTORY_FILE -v update.config.yml -e "sasboot_pw='$ADMINPASS'" -e VIRK_CLONE_DIRECTORY="$VIRK_CLONE_DIRECTORY" -e ORCHESTRATION_DIRECTORY="$ORCHESTRATION_DIRECTORY"
ret="$?"
if [ "$ret" -ne "0" ]; then
    exit $ret
fi

sudo chown -R $USER "${ORCHESTRATION_DIRECTORY}"
pushd "${ORCHESTRATION_DIRECTORY}/sas_viya_playbook"
ansible-playbook -v site.yml
ret="$?"
if [ "$ret" -ne "0" ]; then
    exit $ret
fi
popd
time ansible-playbook -f $FORKS -i $INVENTORY_FILE -v post.deployment.yml -e "cas_virtual_host=$PUBLIC_DNS_NAME"
ret="$?"
if [ "$ret" -ne "0" ]; then
    exit $ret
fi
