$ErrorActionPreference = 'Stop';
$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  softwareName  = 'OSCAR'
  fileType      = 'exe'

  silentArgs   = '/VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-'
  
  validExitCodes= @(0) #please insert other valid exit codes here
  url           = "https://www.apneaboard.com/OSCAR/OSCAR-1.4.0-Win32.exe"
  checksum      = 'D8998239B5FBCC1E9A5A53CB6116368AD760F50C25ECC332196395772E038A98'
  checksumType  = 'sha256'
  url64bit      = "https://www.apneaboard.com/OSCAR/OSCAR-1.4.0-Win64.exe"
  checksum64    = '169497C717FDC50C9A541E8C407AF33E61F34A379D184C61C3483815BAB8CBEC'
  checksumType64= 'sha256'
  destination   = $toolsDir
}

Install-ChocolateyPackage @packageArgs
