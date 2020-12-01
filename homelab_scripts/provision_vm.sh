#!/bin/bash

powershell.exe -File "${SCRIPT_PATH}"/homelab_scripts/pwsh_create_vm.ps1 -VM_NAME "${VM_NAME}" -VM_RAM ${RAM_BYTES} -VM_CORES ${VM_CORES} -TEMPLATE_DIR ${TEMPLATE_DIR} -VM_BASEDIR ${VM_BASEDIR} -TEMPLATE_NAME "${TEMPLATE_NAME}"
setfattr -n user.template -v "${TEMPLATE_NAME}" "${LINUX_VM_BASEDIR}/${VM_NAME}/Virtual Hard Disks/${VM_NAME}.vhdx"
