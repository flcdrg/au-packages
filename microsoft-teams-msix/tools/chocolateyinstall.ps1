$ErrorActionPreference = 'Stop';
$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$packagePath = $(Split-Path -parent $toolsDir)
$filename = "MSTeams.msix"
$installPath = Join-Path $packagePath $filename

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  
  url           = "https://statics.teams.cdn.office.net/production-windows-x86/enterprise/webview2/lkg/MSTeams-x86.msix"
  checksum      = '2AAB6D3DD221CF072FFAC7FB33AC4CEC18036723FF02E946679342655FA3C693'
  checksumType  = 'sha256'
  url64bit      = "https://statics.teams.cdn.office.net/production-windows-x64/enterprise/webview2/lkg/MSTeams-x64.msix"
  checksum64    = 'E7037A45E1F40BA569C92D7C7503F51827C146207B1185BA5FA634B2FA6C5009'
  checksumType64= 'sha256'
  fileFullPath  = $installPath
}

Get-ChocolateyWebFile @packageArgs
