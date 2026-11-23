$ErrorActionPreference = 'Stop'
$toolsDir = "$(Split-Path -Parent $MyInvocation.MyCommand.Definition)"

$urlX64 = 'https://github.com/colbymchenry/codegraph/releases/download/v1.6.4/codegraph-win32-x64.zip'
$urlArm64 = 'https://github.com/colbymchenry/codegraph/releases/download/v1.6.4/codegraph-win32-arm64.zip'
$checksumX64 = '44bc9b5a386b535e2eb8970e9ba8e13e0dd931a357b4adfba8147207e680d5da'
$checksumArm64 = 'be5546b17934a2d57a5e1843da13960a7b84ac85ea51d7cd19c84d8d7759edd0'
$version = $env:ChocolateyPackageVersion

switch ([System.Runtime.InteropServices.RuntimeInformation]::OSArchitecture.ToString()) {
  'X64' {
    $target = 'codegraph-win32-x64'
    $url = $urlX64
    $checksum = $checksumX64
  }
  'Arm64' {
    $target = 'codegraph-win32-arm64'
    $url = $urlArm64
    $checksum = $checksumArm64
  }
  default {
    throw "$env:ChocolateyPackageName supports Windows x64 and ARM64 only. Detected architecture: $([System.Runtime.InteropServices.RuntimeInformation]::OSArchitecture)."
  }
}

$installDir = Join-Path $toolsDir "codegraph-$version"
$bundleDir = Join-Path $installDir $target
$codegraphCommand = Join-Path $bundleDir 'bin\codegraph.cmd'
$nodePath = Join-Path $bundleDir 'node.exe'

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  url           = $url
  checksum      = $checksum
  checksumType  = 'sha256'
  unzipLocation = $installDir
}

. (Join-Path $toolsDir 'helpers.ps1')

# Older package versions have no beforeModify script, so stop processes using the previous version here too.
Stop-CodeGraphProcess

Install-ChocolateyZipPackage @packageArgs

# Keep the bundled runtime off PATH and expose the nested CLI command explicitly.
New-Item -ItemType File -Path "$nodePath.ignore" -Force | Out-Null

$shimPath = Join-Path $env:ChocolateyInstall 'bin\codegraph.exe'
$shimStart = Get-Date
Install-BinFile -Name 'codegraph' -Path $codegraphCommand

# Shimgen does not report failure when the existing shim is locked, leaving it pointing at a removed version.
if (-not (Test-Path $shimPath) -or (Get-Item $shimPath).LastWriteTime -lt $shimStart.AddSeconds(-2)) {
  throw "Failed to update the codegraph shim at '$shimPath'. Close any programs using CodeGraph (such as MCP servers) and retry."
}
