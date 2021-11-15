$ErrorActionPreference = 'Stop';

$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$fileLocation = Join-Path $toolsDir 'YetAnotherFaviconDownloader.plgx'

. "${toolsDir}\common.ps1"

# Now copy the plugin into the KeePass plugins directory
$fileFullPath = Get-KeePassPluginsPath

if (-not (Test-Path $fileFullPath)) {
  New-Item -ItemType Directory $fileFullPath | Out-Null
}
Copy-Item -Path $fileLocation -Destination $fileFullPath