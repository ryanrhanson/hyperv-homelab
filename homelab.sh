#!/bin/bash

#DEFAULTS
#PATHS
TEMPLATE_DIR='G:\snapshot_hdds'
VM_BASEDIR='G:\Hyper-V'
LINUX_TEMPLATE_DIR=$(wslpath -u "${TEMPLATE_DIR}")
LINUX_VM_BASEDIR=$(wslpath -u "${VM_BASEDIR}")
PATH_TO_PUBKEY="/home/ryan/.ssh/id_rsa.pub"
SCRIPT_PATH="$(dirname -- "$(readlink -e "${0}")")/homelab_scripts"
PS_SCRIPT_PATH=$(wslpath -w "${SCRIPT_PATH}")


#Other Arguments
PREP_VM=0
START_VM=0
SET_DESCRIPTION=0
SET_DISTROVER=0
CREATE_TASK=0
DESTROY_VM=0
VM_RAM=3072
VM_CORES=1
VM_NAME="Virtual Machine"
TEMPLATE_NAME="Template.vhdx"
SLEEP_TIME=45
TEMPLATE_DESCRIPTION=""
TEMPLATE_DISTROVER=""
VM_USER="root"
OTHER_ARGS=()

function list_templates () {
	. "${SCRIPT_PATH}"/list_templates.sh
}

function list_vms () {
	. "${SCRIPT_PATH}"/list_vms.sh
}

function info_vm () {
	. "${SCRIPT_PATH}"/vm_info.sh
}

function prep_vm () {
        . "${SCRIPT_PATH}"/get_vm_state.sh
        if [[ ${VM_STATE} != 'Running' ]]; then
         echo "${VM_NAME} is not currently running. Please start the vm and wait at least ${SLEEP_TIME} seconds."
         exit 1
        fi
        . "${SCRIPT_PATH}"/get_vm_ip.sh
        if [[ -z ${VM_IP} ]]; then
          echo "Could not get an IP for ${VM_NAME} - Please try again later or log in through the Hyper-V Console to troubleshoot manually."
          exit 1
        fi
        . "${SCRIPT_PATH}"/prep_vm.sh
}

function start_vm () {
        . "${SCRIPT_PATH}"/start_vm.sh
        echo "Waiting ${SLEEP_TIME} seconds for vm to boot."
        sleep ${SLEEP_TIME}
        . "${SCRIPT_PATH}"/get_vm_ip.sh
        if [[ ${PREP_VM} -eq 1 ]]; then
          prep_vm
        fi
}

function stop_vm () {
        . "${SCRIPT_PATH}"/stop_vm.sh
	if [[ ${DESTROY_VM} -eq 1 ]]; then
	  destroy_vm
	fi
}

function console_vm () {
        vmconnect.exe localhost "${VM_NAME}" &
}

function provision_vm () {
	RAM_BYTES=$(( VM_RAM * 1024*1024 ))
	. "${SCRIPT_PATH}"/provision_vm.sh
	if [[ ${START_VM} -eq 1 ]]; then
	  start_vm
	fi
}

function modify_vm () {
	echo "VM Modification not yet implemented."
#	. "${SCRIPT_PATH}"/modify_vm.sh
}

function login_vm () {
	. "${SCRIPT_PATH}"/get_vm_state.sh
	if [[ ${VM_STATE} != 'Running' ]]; then
	  echo "${VM_NAME} is not currently running. Please start the vm and wait at least ${SLEEP_TIME} seconds."
	  exit 1
	fi
	. "${SCRIPT_PATH}"/get_vm_ip.sh
	if [[ -z ${VM_IP} ]]; then
	  echo "Could not get an IP for ${VM_NAME} - Please try again later or log in through the Hyper-V Console to troubleshoot manually."
	  exit 1
	fi
	ssh "${VM_USER}"@${VM_IP}
}
function destroy_vm () {
	echo "Please be aware that this does not delete the files for the vm (metadata and hard disk). Please delete those manually."
	. "${SCRIPT_PATH}"/destroy_vm.sh
}
function modify_template() {
	. "${SCRIPT_PATH}"/modify_template.sh
}
function forward_wsl() {
	#Placeholder until this can be made into a proper command
	if [ ${CREATE_TASK} -eq 1 ]; then
	 . "${SCRIPT_PATH}"/forward_wsl.sh
        else
 	  echo "Run the following command in an elevated powershell session."
	  echo "Re-run this command with '--create-task' to apply automatically on login."
	  echo "=========="
	  echo "$(cat "${SCRIPT_PATH}"/talk_wsl.ps1)"
	  echo "=========="
	fi
}

function show_help() {

cat << EOF
Usage: homelab.sh command [options]
Commands: provision, start, stop, prep, destroy, list, templates, mod_template, login, console, wsl_forward

    provision            Provision a VM, optionally starting and prepping it
    start                Start a VM
    stop                 Stop a VM
    prep                 Prep VM for login (copy key, set hostname) - Must be running
    destroy              Delete a VM
    login                Display login information
    console              Run vmconnect to open Hyper-V console for given VM
    list                 List all current Hyper-V VMs
    templates            List available template files
    mod_template         Modify attributes for the given template
    wsl_forward          Display powershell command to enable forwarding between WSL and Hyper-V guests

    General Arguments:
    -h|--help            Display this helpfile
    -n|--name            VM Name - Usable with provision, start, stop, prep, destroy, login, console
    -t|--template        Template File - Usable with provision, mod_template
    -c|--cores           Number of virtual cpu cores - Usable with provision
    -m|--memory          VM Ram allocation in MB (ie 3072 for 3GB) - Usable with provision
    -s|--start           Run VM start after provision - Usable with provision
    -p|--prep            Run VM prep after start - Usable with provision, start
    -u|--user            Use specified username - Usable with login
    -d|--destroy         Destroy the VM - Usable with stop
    --create_task        Create scheduled task to automatically setup wsl forwarding on login - Usable with wsl_forward
    --distrover          Set the 'distrover' attribute on the given template - Usable with mod_template
    --description        Set the 'description' attribute on the given template - Usable with mod_template

Example: ./homelab.sh provision -n "Cent8 Test" -p -s -m 2048 -c 2 -t "Cent8-Base.vhdx"

The above will provision a VM named "Cent8 Test" with 2 vCPUs and 2GB RAM from the "Cent8-Base.vhdx" template.
It will also start the VM after provisioning, and run the prep function (copy key in and set hostname).

Example: ./homelab.sh mod_template --distrover "CentOS 7" --description "Base Image" -t "Cent7-Base.vhdx"

The above will set the distrover to "CentOS 7" and description to "Base Image" on the "Cent7-Base.vhdx" template file.
EOF
#
} 

while [[ $# -gt 0 ]]
  do
    arg="${1}"

    case "${arg}" in
      -n|--name)
      VM_NAME="${2}"
      shift
      shift
      ;;
      -p|--prep)
      PREP_VM=1
      shift
      ;;
      -c|--cores)
      VM_CORES=${2}
      shift
      shift
      ;;
      -m|--memory)
      VM_RAM=${2}
      shift
      shift
      ;;
      -t|--template)
      TEMPLATE_NAME="${2}"
      shift
      shift
      ;;
      -h|--help)
      show_help
      shift
      ;;
      -s|--start)
      START_VM=1
      shift
      ;;
      -u|--user)
      VM_USER="${2}"
      shift
      shift
      ;;
      -d|--destroy)
      DESTROY_VM=1
      shift
      ;;
      --distrover)
      SET_DISTROVER=1
      TEMPLATE_DISTROVER="${2}"
      shift
      shift
      ;;
      --create_task)
      CREATE_TASK=1
      shift
      ;;
      --description)
      SET_DESCRIPTION=1
      TEMPLATE_DESCRIPTION="${2}"
      shift
      shift
      ;;
      *)
      OTHER_ARGS+=("${1}")
      shift
      ;;
    esac
done

for func in "${OTHER_ARGS[@]}"
  do
    case "${func}" in
      list)
      list_vms
      break
      ;;
      provision)
      provision_vm
      break
      ;;
      modify)
      modify_vm
      break
      ;;
      prep)
      prep_vm
      break
      ;;
      login)
      login_vm
      break
      ;;
      destroy)
      destroy_vm
      break
      ;;
      templates)
      list_templates
      break
      ;;
      mod_template)
      modify_template
      break
      ;;
      console)
      console_vm
      break
      ;;
      start)
      start_vm
      break
      ;;
      stop)
      stop_vm
      break
      ;;
      wsl_forward)
      forward_wsl
      break
      ;;
      *)
      echo "Unknown Command: \"${func}\""
      ;;
    esac
done
