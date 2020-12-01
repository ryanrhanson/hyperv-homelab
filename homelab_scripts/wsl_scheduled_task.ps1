$StAct = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-command Get-NetIPInterface | where {`$_.InterfaceAlias -eq 'vEthernet (WSL)' -or `$_.InterfaceAlias -eq 'vEthernet (Default Switch)'} | Set-NetIPInterface -Forwarding Enabled"
$StUser = [System.Security.Principal.WindowsIdentity]::GetCurrent().Name
$StPrin = New-ScheduledTaskPrincipal $StUser -RunLevel Highest
$StTrig = New-ScheduledTaskTrigger -AtLogon -User $StUser

$StTask = New-ScheduledTask -Action $StAct -Principal $StPrin -Trigger $StTrig

Register-ScheduledTask "Homelab WSL Forwarding" -InputObject $StTask

Start-ScheduledTask -TaskName "Homelab WSL Forwarding"
