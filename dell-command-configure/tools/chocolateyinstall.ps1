$ErrorActionPreference = 'Stop';
$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$fileLocation = 'https://dl.dell.com/FOLDER11549484M/2/Dell-Command-Configure_H16FW_WIN_4.12.0.95_A00_01.EXE'

#Based on NO DETECTION IN PRO
$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  softwareName  = 'dell-command-configure*'
  file          = $fileLocation
  fileType      = 'exe'
  silentArgs    = "/s"
  
  validExitCodes= @(0) #please insert other valid exit codes here
  url           = ""  #download URL, HTTPS preferrred
  checksum      = '41FF968F0FF4B67FFF2A8ABB89B61F9380AF798802FA714234DF3F1887CF6BFD'
  checksumType  = 'sha256'
  destination   = $toolsDir

  # The dl.dell.com site seems to reject requests from the Chocolatey user agent
  options       = @{ Headers = @{ 'User-Agent' = 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:122.0) Gecko/20100101 Firefox/122.0' } }

}

Install-ChocolateyPackage @packageArgs
