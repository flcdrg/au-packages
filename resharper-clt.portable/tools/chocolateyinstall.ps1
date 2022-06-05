$ErrorActionPreference = 'Stop'; # stop on all errors

$url = 'https://download.jetbrains.com/resharper/dotUltimate.2022.2.EAP3/JetBrains.ReSharper.CommandLineTools.2022.2.EAP3.Checked.zip'
$checksum = 'aa91205709fe3fc1683d68b4d456c7c60840dc76991e4f01ee4be2173f2533bc'

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
