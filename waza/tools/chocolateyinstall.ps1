$ErrorActionPreference = 'Stop'
$toolsDir = Split-Path -Parent $MyInvocation.MyCommand.Definition

$releaseTag = 'v0.40.1'
$checksum64 = '3dddc02642ff92916a3c9d03a793e170c5af6d3a17f9a23ed3fe4fa70918608e'
$checksumArm64 = 'a1319a0edc7d72066d965c46f131b4b564c93f430ff6d0667b684e974c2c7197'

# OSArchitecture reports the native OS architecture even when PowerShell itself runs emulated (e.g. x64 on ARM64)
$osArchitecture = [System.Runtime.InteropServices.RuntimeInformation]::OSArchitecture

switch ($osArchitecture) {
  'Arm64' {
    $architecture = 'arm64'
    $checksum = $checksumArm64
    break
  }
  'X64' {
    $architecture = 'amd64'
    $checksum = $checksum64
    break
  }
  default {
    throw "Unsupported Waza architecture: $osArchitecture. Supported architectures are x64 and ARM64."
  }
}

$url = "https://github.com/microsoft/waza/releases/download/$releaseTag/waza-windows-$architecture.exe"

Get-ChocolateyWebFile `
  -PackageName $env:ChocolateyPackageName `
  -FileFullPath (Join-Path $toolsDir 'waza.exe') `
  -Url $url `
  -Checksum $checksum `
  -ChecksumType 'sha256'
