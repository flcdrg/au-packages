$ErrorActionPreference = 'Stop'
$toolsDir = Split-Path -Parent $MyInvocation.MyCommand.Definition

$releaseTag = 'v0.40.0'
$checksum64 = 'a388f5577ecbf10d4edd775a5e2c37a7a5cbdd0758e66d8718992942687dd2e4'
$checksumArm64 = '8e17674f7c161add85e079a8259d3e4d30667ff28805e264227a99dfe7dbc8dd'

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
