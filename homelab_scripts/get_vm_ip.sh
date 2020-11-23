#!/bin/bash

VM_IP=$(powershell.exe Get-VMNetworkAdapter "\"${VM_NAME}\"" \| Select-Object -Property IPAddresses -ExpandProperty IPAddresses \| Select-Object -First 1 | sed $'s/[^[:print:]\t]//g')
