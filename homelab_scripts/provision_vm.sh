#!/bin/bash
#VM_NAME="${1}"
#TEMPLATE_NAME="${2}"
#RAM_MBYTES="${3}"
#RAM_KBYTES="$(( $RAM_MBYTES * 1024 ))"
#RAM_BYTES="$(( $RAM_KBYTES * 1024 ))"
#TEMPLATE_DIR='G:\snapshot_hdds'
#VM_BASEDIR='G:\Hyper-V\'
#VM_HD_DIR="\'G:\\Hyper-V\\${VM_NAME}\\Virtual Hard Disks\\\'"

powershell.exe -File pwsh_create_vm.ps1 -VM_NAME "${VM_NAME}" -VM_RAM ${RAM_BYTES} -VM_CORES 3 -TEMPLATE_DIR ${TEMPLATE_DIR} -VM_BASEDIR ${VM_BASEDIR} -TEMPLATE_NAME "${TEMPLATE_NAME}"

powershell.exe Get-VM
