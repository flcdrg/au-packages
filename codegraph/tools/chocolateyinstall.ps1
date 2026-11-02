$ErrorActionPreference = 'Stop'
$toolsDir = "$(Split-Path -Parent $MyInvocation.MyCommand.Definition)"

$urlX64 = 'https://github.com/colbymchenry/codegraph/releases/download/v1.6.2/codegraph-win32-x64.zip'
$urlArm64 = 'https://github.com/colbymchenry/codegraph/releases/download/v1.6.2/codegraph-win32-arm64.zip'
$checksumX64 = '7455e817ee8032666867a1badeb799b8a884c5f4fea9b444e088a02069b6deea'
$checksumArm64 = '308f7bf92e7886f4d5f767a4755d703e92d5cae78ac042b8907f1e99db0fc071'
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
