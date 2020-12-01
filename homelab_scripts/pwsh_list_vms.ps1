$VMs = Get-VM
$VMArray = @()
ForEach ( $VM in $VMs ) {
    $object = New-Object -TypeName PSObject
    $object | Add-Member -Name 'Name' -MemberType Noteproperty -Value $VM.Name
    $object | Add-Member -Name 'State' -MemberType Noteproperty -Value $VM.state
    $object | Add-Member -Name 'CPUs' -MemberType Noteproperty -Value $VM.ProcessorCount
    $object | Add-Member -Name 'mRAM' -MemberType Noteproperty -Value "$([math]::round($VM.MemoryMaximum/1MB, 2))MB"
    $object | Add-Member -Name 'Uptime' -MemberType Noteproperty -Value $VM.Uptime.ToString("hh\:mm\:ss")
    $VMIps = $VM.NetworkAdapters.IpAddresses | Where {$_ -notmatch "^fe80::"}
    $object | Add-Member -Name 'IPs' -MemberType NoteProperty -Value ($($VMIps -join "`n" | Out-String).Trim())
    $VMArray += $object

}

$VMArray | Format-Table Name, State, Uptime, CPUs, @{Label='Max RAM';Expression={($_.mRAM)}}, @{Label='IP Address(es)';Expression={($_.IPs )}} -Wrap
