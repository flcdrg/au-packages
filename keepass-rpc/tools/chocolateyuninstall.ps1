$ErrorActionPreference = 'Stop';
$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

. "${toolsDir}\common.ps1"


$fileFullPath = Get-KeePassPluginsPath

$fileFullPath = [IO.Path]::Combine($fileFullPath, "KeePassRPC.plgx")

if (Test-Path $fileFullPath) {
  Remove-Item $fileFullPath -Force
}