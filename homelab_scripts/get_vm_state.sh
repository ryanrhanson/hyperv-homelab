#!/bin/bash
VM_STATE=$(powershell.exe Get-VM "\"${VM_NAME}\"" \| Select-Object -ExpandProperty State | sed $'s/[^[:print:]\t]//g')
