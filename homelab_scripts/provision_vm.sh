#!/bin/bash

powershell.exe -File pwsh_create_vm.ps1 -VM_NAME "${VM_NAME}" -VM_RAM ${RAM_BYTES} -VM_CORES 3 -TEMPLATE_DIR ${TEMPLATE_DIR} -VM_BASEDIR ${VM_BASEDIR} -TEMPLATE_NAME "${TEMPLATE_NAME}"

powershell.exe Get-VM
