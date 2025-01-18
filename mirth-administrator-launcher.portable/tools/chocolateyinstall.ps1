$ErrorActionPreference = 'Stop';
$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  fileType      = 'zip'
  
  validExitCodes= @(0)
  url           = "https://s3.amazonaws.com/downloads.mirthcorp.com/connect-client-launcher/mirth-administrator-launcher-latest-windows.zip"
  checksum      = '66D14EDD32BDF00BBB41AADB6798B8F2ECDAED8655F2E5A1EAFD540A24DE0123'
  checksumType  = 'sha256'
  url64bit      = "https://s3.amazonaws.com/downloads.mirthcorp.com/connect-client-launcher/mirth-administrator-launcher-latest-windows-x64.zip"
  checksum64    = 'A68AB448CBFD212154BA7BCEADE79492EF0273453C4EF573FD126862D0082824'
  checksumType64= 'sha256'
  destination   = $toolsDir
}

Install-ChocolateyZipPackage @packageArgs

$files = get-childitem $toolsDir -include *.exe -recurse

foreach ($file in $files) {
  if (!($file.Name -eq "launcher.exe")) {
    #generate an ignore file
    New-Item "$file.ignore" -type file -force | Out-Null
  }
}