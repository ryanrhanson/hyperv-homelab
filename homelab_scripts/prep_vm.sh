#!/bin/bash

echo Copying Public key ${PATH_TO_PUBKEY} to ${VM_NAME}
mkdir -p ~/.wsltmpdir
TEMP_PATH=$(readlink -f ~/.wsltmpdir)
cp -a "${PATH_TO_PUBKEY}" "${TEMP_PATH}/authorized_keys"

powershell.exe Copy-VMFile -Name "\"${VM_NAME}\"" -SourcePath "\\\\wsl\$\\Ubuntu\"${TEMP_PATH}"\\authorized_keys\" -DestinationPath '/root/.ssh/' -FileSource Host -Force -CreateFullPath

rm -rf "${TEMP_PATH}"

echo Logging in once to set hostname.

ssh root@${VM_IP} -C "hostnamectl set-hostname ${VM_NAME// /-}"
