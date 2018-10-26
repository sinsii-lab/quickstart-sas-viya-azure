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
echo "$@" >> /tmp/commands.log
export SCRIPT_PHASE="$1"
if [ -z "$SCRIPT_PHASE" ]; then
	export SCRIPT_PHASE="1"
fi
export https_location="$2"
export https_sas_key="$3"
export license_file_uri="$4"
export PRIMARY_USER="$5"
export ADMINPASS="$6"
if [ -z "$ADMINPASS" ]; then
	export ADMINPASS="adminPass"
fi
export USERPASS="$7"

export DIRECTORY_NFS_SHARE="/exports/bastion"
export PRIVATE_SUBNET_IPRANGE="$8"
export PUBLIC_DNS_NAME="$9"

export DIRECTORY_ANSIBLE_KEYS="${DIRECTORY_NFS_SHARE}/setup/ansible_key"
export DIRECTORY_READYNESS_FLAGS="${DIRECTORY_NFS_SHARE}/setup/readyness_flags"
export DIRECTORY_GIT_LOCAL_COPY="${DIRECTORY_NFS_SHARE}/setup/code"
export DIRECTORY_LICENSE_FILE="${DIRECTORY_NFS_SHARE}/setup/license"
export DIRECTORY_SSL_JSON_FILE="${DIRECTORY_NFS_SHARE}/setup/ssl"
export DIRECTORY_ANSIBLE_INVENTORIES="${DIRECTORY_NFS_SHARE}/setup/ansible/inventory"
export DIRECTORY_ANSIBLE_GROUPS="${DIRECTORY_NFS_SHARE}/setup/ansible/groups"
export FILE_LICENSE_FILE="${DIRECTORY_LICENSE_FILE}/license_file.zip"
export FILE_SSL_JSON_FILE="${DIRECTORY_SSL_JSON_FILE}/loadbalancer.pfx.json"
export FILE_CA_B64_FILE="${DIRECTORY_SSL_JSON_FILE}/sas_certificate_all.crt.b64.txt"



export ORCHESTRATION_DIRECTORY="${DIRECTORY_NFS_SHARE}/setup/orchestration"
export VIRK_CLONE_DIRECTORY="${ORCHESTRATION_DIRECTORY}/sas_viya_playbook/virk"
export CODE_DIRECTORY="${DIRECTORY_NFS_SHARE}/setup/code"

#./bastion_bootstrap.sh --enable false
if [ "$SCRIPT_PHASE" -eq "1" ]; then
	echo "running ansible prerequisites install"
	${ScriptDirectory}/ansiblecontroller_prereqs.sh
# here we return the sizing for the cas controller
elif [ "$SCRIPT_PHASE" -eq "2" ]; then
	cat "${DIRECTORY_LICENSE_FILE}/cas_size.txt" |tr -d '\n'
# here we return the ssl certificate for the system (has to be done in 2 pieces because we only get to return 4096 charectors)
elif [ "$SCRIPT_PHASE" -eq "3" ]; then
	cat "${FILE_SSL_JSON_FILE}.1" |tr -d '\n'
elif [ "$SCRIPT_PHASE" -eq "4" ]; then
	cat "${FILE_SSL_JSON_FILE}.2" |tr -d '\n'
elif [ "$SCRIPT_PHASE" -eq "5" ]; then
	echo "waiting for sync with client servers"
	${DIRECTORY_GIT_LOCAL_COPY}/scripts/ansiblecontroller_waitforsync.sh
	echo "Install Prep"
	su $PRIMARY_USER -c	"${DIRECTORY_GIT_LOCAL_COPY}/scripts/install_pre_orchestration.sh"
	ret="$?"
    if [ "$ret" -ne "0" ]; then
        exit $ret
    fi
elif [ "$SCRIPT_PHASE" -eq "6" ]; then
    cat "$FILE_CA_B64_FILE"|tr -d '\n'
elif [ "$SCRIPT_PHASE" -eq "7" ]; then
	echo "Starting Actual Install"
	su $PRIMARY_USER -c "${DIRECTORY_GIT_LOCAL_COPY}/scripts/install_run_orchestration_wrapper.sh"
	ret="$?"
    if [ "$ret" -ne "0" ]; then
        exit $ret
    fi
elif [ "$SCRIPT_PHASE" -eq "8" ]; then
	echo "Starting Actual Install"
	su $PRIMARY_USER -c "${DIRECTORY_GIT_LOCAL_COPY}/scripts/install_post_orchestration.sh"
	ret="$?"
    if [ "$ret" -ne "0" ]; then
        exit $ret
    fi
fi
