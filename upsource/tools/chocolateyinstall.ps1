$ErrorActionPreference = 'Stop';

#Based on NO DETECTION IN PRO
$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  softwareName  = 'upsource*'
  fileType      = 'zip'
  silentArgs    = "/s"
  validExitCodes= @(0) #please insert other valid exit codes here
  url           = "https://download.jetbrains.com/upsource/upsource-2020.1.1802.zip"  #download URL, HTTPS preferrred
  checksum      = '68b4a13712cd4c48dc0109c5bcb1bee28b299ecaa70e773a7ed00854bc523c8e'
  checksumType  = 'sha256'
  UnzipLocation    = 'c:\'
}

Install-ChocolateyZipPackage @packageArgs

## See https://chocolatey.org/docs/helpers-reference

c:\upsource-2020.1.1802\bin\upsource.bat start