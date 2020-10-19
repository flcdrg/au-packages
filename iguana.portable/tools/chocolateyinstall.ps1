$ErrorActionPreference = 'Stop';

$packageName= 'iguana.portable'
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url64      = 'http://dl.interfaceware.com/iguana/windows/6_1_3/iguana_noinstaller_6_1_3_windows_x64.zip'
$checksum64 = '600c2fb8b61f063279b1c11e7f951e23f19ee09e4cf0edfbe96537683518c870'

$packageArgs = @{
  packageName   = $packageName
  unzipLocation = $toolsDir
  url64bit      = $url64

  softwareName  = 'iguana.portable*'

  checksum64    = $checksum64
  checksumType64= 'sha256'
}

Install-ChocolateyZipPackage @packageArgs

$files = get-childitem $toolsDir -include *.exe -recurse

foreach ($file in $files) {
  #generate an ignore file
  New-Item "$file.ignore" -type file -force | Out-Null
}
