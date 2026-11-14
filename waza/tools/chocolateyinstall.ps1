$ErrorActionPreference = 'Stop'
$toolsDir = Split-Path -Parent $MyInvocation.MyCommand.Definition

$releaseTag = 'v0.41.0'
$checksum64 = '1c4e61f53e2db782f403f1ef566ab4f112282c71ddc3640d3ffe8cba503d02f4'
$checksumArm64 = '5a26c9da90a32cf9c0600dc6ad66859e3fd8f4f6420f26b35cd0edc5e19b2f99'

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
