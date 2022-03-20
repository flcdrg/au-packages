$ErrorActionPreference = 'Stop';
$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  fileType      = 'zip'
  
  validExitCodes= @(0)
  # move-transition-2.5.8-windows-installer.zip
  url           = "https://obsproject.com/forum/resources/move-transition.913/version/4040/download?file=80289"
  checksum      = '891ABE7466FB039C833FBCE9759989ADBF0EFA93BA275392E3F0A291936607C3'
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