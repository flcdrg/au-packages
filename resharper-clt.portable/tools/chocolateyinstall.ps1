﻿$ErrorActionPreference = 'Stop'; # stop on all errors

$url = 'https://download.jetbrains.com/resharper/dotUltimate.2023.3.EAP5/JetBrains.ReSharper.CommandLineTools.2023.3.EAP5.Checked.zip'
$checksum = 'a94ced4ef0157d5a3b4f22ccaa0486447844f713a9ad99af35b55216fc51e849'

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
