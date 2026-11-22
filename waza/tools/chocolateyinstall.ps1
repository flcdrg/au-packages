$ErrorActionPreference = 'Stop'
$toolsDir = Split-Path -Parent $MyInvocation.MyCommand.Definition

$releaseTag = 'v0.42.0'
$checksum64 = '33bba90738e82fd7bfdc707ee8cfbf1f078b861c4d9488f8e972a6f4de4d9844'
$checksumArm64 = 'aa0ee85296cdd864a57b271dd3f82933bd1238a012f2c64bd6cf18f547dc53d9'

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
