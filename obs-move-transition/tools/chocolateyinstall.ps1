$ErrorActionPreference = 'Stop';
$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  fileType      = 'zip'
  
  validExitCodes= @(0)
  url           = "https://obsproject.com/forum/resources/move-transition.913/version/2713/download?file=60710"
  checksum      = '489C18EDA87B32F6815DF28417AC7AD8145AC318D3FCDEB190FE55FF0B0C297B'
  checksumType  = 'sha256'
  destination   = $toolsDir
}

Install-ChocolateyZipPackage @packageArgs

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  fileType      = "exe"
  softwareName  = 'Move Transition*'
  silentArgs    = "/VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-"
  file          = "$($toolsDir)\move-transition-installer.exe"
  validExitCodes = @(0)
}

Install-ChocolateyInstallPackage @packageArgs