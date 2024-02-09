$ErrorActionPreference = 'Stop'

$packageName = $env:ChocolateyPackageName

$toolsPath = Split-Path $MyInvocation.MyCommand.Definition

$packageArgs = @{
  PackageName    = $packageName
  FileFullPath64 = Get-Item $toolsPath\*-windows-amd64.tar.gz
  Destination    = $toolsPath
}
Get-ChocolateyUnzip @packageArgs

if (Test-Path "$toolsPath\kubeseal*.tar") {
  $packageArgs2 = @{
    PackageName    = $packageName
    FileFullPath64 = Get-Item $toolsPath\*-windows-amd64.tar
    Destination    = $toolsPath
  }
  Get-ChocolateyUnzip @packageArgs2

  Remove-Item "$toolsPath\kubeseal*.tar"
}
