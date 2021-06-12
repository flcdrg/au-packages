$ErrorActionPreference = 'Stop'; # stop on all errors

$url = 'https://download.jetbrains.com/resharper/dotUltimate.2021.2.EAP3/JetBrains.ReSharper.CommandLineTools.2021.2.EAP3.Checked.zip'
$checksum = 'a703d1183ff51f35ca7dcf36ea0c14bd8334f4bbf0f1ef1d8b72128bea925d86'

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
