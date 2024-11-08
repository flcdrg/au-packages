$ErrorActionPreference = 'Stop'; # stop on all errors

$url = 'https://download.jetbrains.com/resharper/dotUltimate.2024.3.RC1/JetBrains.ReSharper.CommandLineTools.2024.3.RC1.Checked.zip'
$checksum = '92a9a5f8273f6133d11052f9dc2d9eb76170b6f0e73283c7267718773fe4c4ff'

$installPath  = $(Split-Path -parent $MyInvocation.MyCommand.Definition)

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  url           = $url
  UnzipLocation = $installPath
  checksum      = $checksum
  ChecksumType  = 'sha256'
}

Install-ChocolateyZipPackage @packageArgs

# Exclude from shimming
$files = Get-ChildItem $installPath -Recurse -Include *.exe -Exclude cleanupcode*.exe,dupfinder.exe,inspectcode*.exe

foreach ($file in $files) {
  New-Item "$file.ignore" -type file -force | Out-Null
}
