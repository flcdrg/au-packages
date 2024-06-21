$ErrorActionPreference = 'Stop';
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

. "${toolsDir}\common.ps1"

$url           = 'https://github.com/kee-org/keepassrpc/releases/download/v2.0.2/KeePassRPC.plgx'
$checksum      = 'fad2fa6f502b9b6624385c952bfe9d5f18077c843e855e738b34a88d5b6fc67e'

$packagePath = $(Split-Path -parent $toolsDir)
$downloadPath = Join-Path $packagePath "KeePassRPC.plgx"

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  url           = $url
  checksum      = $checksum
  checksumType  = 'sha256'
  FileFullPath   = $downloadPath
}

Get-ChocolateyWebFile @packageArgs

# Now copy the plugin into the KeePass plugins directory
$fileFullPath = Get-KeePassPluginsPath

if (-not (Test-Path $fileFullPath)) {
  New-Item -ItemType Directory $fileFullPath | Out-Null
}

Copy-Item -Path $downloadPath -Destination $fileFullPath -Force
