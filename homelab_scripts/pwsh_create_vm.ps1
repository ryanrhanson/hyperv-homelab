param ($VM_NAME, $VM_RAM, $VM_CORES, $TEMPLATE_DIR, $VM_BASEDIR, $TEMPLATE_NAME)

New-Item -itemtype directory -Path "$VM_BASEDIR\$VM_NAME\Virtual Hard Disks" -Force | Out-Null
Copy-Item -Path "$TEMPLATE_DIR\$TEMPLATE_NAME" -Destination "$VM_BASEDIR\$VM_NAME\Virtual Hard Disks\$VM_NAME.vhdx" -Recurse -Force | Out-Null
New-VM -Name "$VM_NAME" -MemoryStartupBytes $VM_RAM -Generation 2 -Path "$VM_BASEDIR" -VHDPath "$VM_BASEDIR\$VM_NAME\Virtual Hard Disks\$VM_NAME.vhdx" -SwitchName 'Default Switch' | Out-Null
Set-VM -Name "$VM_NAME" -CheckpointType Disabled -ProcessorCount $VM_CORES -MemoryMaximumBytes $VM_RAM | Out-Null
Set-VMFirmware -VMName "$VM_NAME" -SecureBootTemplate MicrosoftUEFICertificateAuthority | Out-Null
Enable-VMIntegrationService -VMName "$VM_NAME" -Name "Guest Service Interface"
