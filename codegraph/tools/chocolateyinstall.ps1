$ErrorActionPreference = 'Stop'
$toolsDir = "$(Split-Path -Parent $MyInvocation.MyCommand.Definition)"

$urlX64 = 'https://github.com/colbymchenry/codegraph/releases/download/v1.6.3/codegraph-win32-x64.zip'
$urlArm64 = 'https://github.com/colbymchenry/codegraph/releases/download/v1.6.3/codegraph-win32-arm64.zip'
$checksumX64 = 'cc1ab45c49a8b0897ea22f458c2905701e73d072d4875177cfca3e9c2fc36fb3'
$checksumArm64 = '3a7e3ada67070c0afbbc8edbcd530cf34478b40fd03481eed8a7ce97eed1e26a'
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

Install-ChocolateyZipPackage @packageArgs

# Keep the bundled runtime off PATH and expose the nested CLI command explicitly.
New-Item -ItemType File -Path "$nodePath.ignore" -Force | Out-Null
Install-BinFile -Name 'codegraph' -Path $codegraphCommand
