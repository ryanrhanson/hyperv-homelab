#!/bin/bash
#VM_NAME="${1}"
#PREP_VM="${2}"

powershell.exe Start-VM "\"${VM_NAME}\""
#echo Waiting 30 seconds for startup...
#sleep 30
#VM_IP=$(powershell.exe Get-VMNetworkAdapter "\"${VM_NAME}\"" \| Select-Object -Property IPAddresses -ExpandProperty IPAddresses \| Select-Object -First 1 | sed $'s/[^[:print:]\t]//g')
#echo "Primary IP for ${VM_NAME} is ${VM_IP}."
#
#if [ ${PREP_VM} -eq 0 ]; then
#	echo Skipping prep.
#	continue
#else
#	echo "Prepping ${VM_NAME} for login."
#	bash ~/prep_vm.sh "${VM_NAME}" ~/.ssh/id_rsa.pub
#fi
#echo Logging in once to set hostname.
#ssh root@${VM_IP} -C "hostnamectl set-hostname ${VM_NAME// /-}"
