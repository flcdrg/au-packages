$ErrorActionPreference = 'Stop'; # stop on all errors

$url = 'https://download-cdn.jetbrains.com/resharper/dotUltimate.2022.1.2/JetBrains.dotMemory.Console.windows-x64.2022.1.2.zip'
$checksum = '4be497788ff221f115ab9280190e4286a343eabb0d4f68f3a4e169ba8c4da6f4'

$installPath  = $(Split-Path -parent $MyInvocation.MyCommand.Definition)

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  url           = $url
  UnzipLocation = $installPath
  checksum      = $checksum
  ChecksumType  = 'sha256'
}

Install-ChocolateyZipPackage @packageArgs