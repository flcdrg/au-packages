$ErrorActionPreference = 'Stop'

# Stop any existing processes
Get-Process ZoomIt -ErrorAction SilentlyContinue | Stop-Process
Get-Process ZoomIt64 -ErrorAction SilentlyContinue | Stop-Process

$packageName = 'zoomit'
$url = 'https://download.sysinternals.com/files/ZoomIt.zip'
$checksum = '104E986CDB8AD44A62393E87E326C6861E9E71D1F801101DA796E72ACF54C811'

$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
Install-ChocolateyZipPackage -PackageName "$packageName" `
                             -Url "$url" `
                             -UnzipLocation "$toolsDir" `
                             -Checksum "$checksum" `
                             -ChecksumType 'sha256'

Write-Verbose "Accepting license..."
$regRoot = 'HKCU:\Software\Sysinternals'
$regPkg = 'ZoomIt'
$regPath = Join-Path $regRoot $regPkg
if (!(Test-Path $regRoot)) {New-Item -Path "$regRoot"}
if (!(Test-Path $regPath)) {New-Item -Path "$regRoot" -Name "$regPkg"}
Set-ItemProperty -Path "$regPath" -Name EulaAccepted -Value 1
if ((Get-ItemProperty -Path "$regPath").EulaAccepted -ne 1) {
  throw "Failed setting registry value."
}
