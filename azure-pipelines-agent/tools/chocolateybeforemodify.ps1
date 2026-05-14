$pp = Get-PackageParameters

if (!$pp['NoStopService']) {
    Get-Service | Where-Object { $_.Name -like "vstsagent*" } | Stop-Service
}