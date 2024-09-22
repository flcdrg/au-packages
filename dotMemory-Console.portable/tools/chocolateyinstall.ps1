$ErrorActionPreference = 'Stop'; # stop on all errors

$url = 'https://download-cdn.jetbrains.com/resharper/dotUltimate.2024.2.5/JetBrains.dotMemory.Console.windows-x64.2024.2.5.zip'
$checksum = '8d02437a72d14ebcf099b6cca54e4c8a650e7a3cd41a401cf42d50dc1d683dc2'

$installPath  = $(Split-Path -parent $MyInvocation.MyCommand.Definition)

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  url           = $url
  UnzipLocation = $installPath
  checksum      = $checksum
  ChecksumType  = 'sha256'
}

Install-ChocolateyZipPackage @packageArgs