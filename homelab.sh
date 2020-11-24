#!/bin/bash

#DEFAULTS
#PATHS
LINUX_TEMPLATE_DIR="/mnt/g/snapshot_hdds"
TEMPLATE_DIR='G:\snapshot_hdds'
VM_BASEDIR='G:\Hyper-V'
PATH_TO_PUBKEY="/home/ryan/.ssh/id_rsa.pub"

#Other Arguments
PREP_VM=0
START_VM=0
SET_DESCRIPTION=0
SET_DISTROVER=0
VM_RAM=3072
VM_CORES=1
VM_NAME="Virtual Machine"
TEMPLATE_NAME="Template.vhdx"
SLEEP_TIME=45
TEMPLATE_DESCRIPTION=""
TEMPLATE_DISTROVER=""
OTHER_ARGS=()

function list_templates () {
	. homelab_scripts/list_templates.sh
}

function list_vms () {
	. homelab_scripts/list_vms.sh
}

function start_vm () {
        . homelab_scripts/start_vm.sh
        echo "Waiting ${SLEEP_TIME} seconds for vm to boot."
        sleep ${SLEEP_TIME}
        . homelab_scripts/get_vm_ip.sh
        if [[ ${PREP_VM} -eq 1 ]]; then
          prep_vm
        fi
}
function stop_vm () {
        . homelab_scripts/stop_vm.sh
}
function console_vm () {
        vmconnect.exe localhost "${VM_NAME}"
}

function provision_vm () {
	RAM_BYTES=$(( VM_RAM * 1024*1024 ))
	powershell.exe -File homelab_scripts/pwsh_create_vm.ps1 -VM_NAME "${VM_NAME}" -VM_RAM ${RAM_BYTES} -VM_CORES ${VM_CORES} -TEMPLATE_DIR ${TEMPLATE_DIR} -VM_BASEDIR ${VM_BASEDIR} -TEMPLATE_NAME "${TEMPLATE_NAME}"
	if [[ ${START_VM} -eq 1 ]]; then
	  start_vm
	fi
}

function prep_vm () {
	. homelab_scripts/get_vm_state.sh
	if [[ ${VM_STATE} != 'Running' ]]; then
	 echo "${VM_NAME} is not currently running. Please start the vm and wait at least 30 seconds."
	 exit 1
	fi
	. homelab_scripts/get_vm_ip.sh
	if [[ -z ${VM_IP} ]]; then 
	  echo "Could not get an IP for ${VM_NAME} - Please try again later or log in through the Hyper-V Console to troubleshoot manually."
	  exit 1
	fi
	. homelab_scripts/prep_vm.sh
}

function modify_vm () {
	echo "VM Modification not yet implemented."
#	. homelab_scripts/modify_vm.sh
}

function login_vm () {
	. homelab_scripts/get_vm_state.sh
	if [[ ${VM_STATE} != 'Running' ]]; then
	  echo "${VM_NAME} is not currently running. Please start the vm and wait at least ${SLEEP_TIME} seconds."
	  exit 1
	fi
	. homelab_scripts/get_vm_ip.sh
	if [[ -z ${VM_IP} ]]; then
	  echo "Could not get an IP for ${VM_NAME} - Please try again later or log in through the Hyper-V Console to troubleshoot manually."
	  exit 1
	fi
	echo "You can log in to ${VM_NAME} by running ssh root@${VM_IP}."
}
function destroy_vm () {
	echo "Please be aware that this does not delete the files for the vm (metadata and hard disk). Please delete those manually."
	. homelab_scripts/destroy_vm.sh
}
function modify_template() {
	. homelab_scripts/modify_template.sh
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
      --distrover)
      SET_DISTROVER=1
      TEMPLATE_DISTROVER="${2}"
      shift
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
      *)
      echo "Unknown Command: \"${func}\""
      ;;
    esac
done

#function list_vms {
#}

#list_templates () {
#	bash list_templates.sh
#}


#echo Template Dir: "${TEMPLATE_DIR}"
#echo VM Basedir: "${VM_BASEDIR}"
#echo Prep? ${PREP_VM}
#echo Function: ${FUNCTION}
#echo RAM: ${VM_RAM}
#echo Cores: ${VM_CORES}
#echo Name: "${VM_NAME}"
#echo Template Name: "${TEMPLATE_NAME}"
#echo Other: "${OTHER_ARGS[@]}"
