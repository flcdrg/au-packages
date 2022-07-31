$ErrorActionPreference = 'Stop'; # stop on all errors

$url = 'https://download.jetbrains.com/resharper/JetBrains.dotMemoryUnit.3.2.20220510.zip'
$checksum = '6f85246c8828b7d874d21befa403b866fd87a4a51f1bff19ec5f3d559b55c1ab'

$installPath  = $(Split-Path -parent $MyInvocation.MyCommand.Definition)

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  url           = $url
  UnzipLocation = $installPath
  checksum      = $checksum
  ChecksumType  = 'sha256'
}

Install-ChocolateyZipPackage @packageArgs

# Exclude ancillory executables from shimming
$files = Get-ChildItem $installPath -Recurse -Include *.exe -Exclude dotMemoryUnit.exe

foreach ($file in $files) {
  New-Item "$file.ignore" -type file -force | Out-Null
}
