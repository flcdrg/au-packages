$ErrorActionPreference = 'Stop'
$toolsDir = Split-Path -Parent $MyInvocation.MyCommand.Definition

$releaseTag = 'v0.39.1'
$checksum64 = '719794d0986730c61fa0fbeedc01743d3c0973d953640db55c9d239a9be8c5bf'
$checksumArm64 = '8eb30139af2766247277c252a9deaf11d3b3e216fc89e157e3a3b63b854dc8d7'

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
