$ErrorActionPreference = 'Stop';
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

. "${toolsDir}\common.ps1"

$url           = 'https://github.com/kee-org/keepassrpc/releases/download/v1.16.0/KeePassRPC.plgx'
$checksum      = 'a7975896e0ab5c02a1061966eac43741013780b309cc466c1d7c069d5797168b'

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
