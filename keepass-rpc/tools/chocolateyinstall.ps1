$ErrorActionPreference = 'Stop';
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

. "${toolsDir}\common.ps1"

$url           = 'https://github.com/kee-org/keepassrpc/releases/download/v1.14.0/KeePassRPC.plgx'
$checksum      = '1c410cc93c0252e7cfdb02507b8172c13e18d12c97f08630b721d897dc9b8b24'

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
