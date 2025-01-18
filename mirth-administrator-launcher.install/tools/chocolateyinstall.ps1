$ErrorActionPreference = 'Stop';
$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  softwareName  = 'Mirth Connect Administrator Launcher *'
  fileType      = 'exe'
  silentArgs    = "-q -console"
  
  validExitCodes= @(0) #please insert other valid exit codes here
  url           = "https://s3.amazonaws.com/downloads.mirthcorp.com/connect-client-launcher/mirth-administrator-launcher-latest-windows.exe"  #download URL, HTTPS preferrred
  checksum      = '8957EBFE99846D5192DB2F64A963F34A189D81C5A9EA1994A5CA990161D57A82'
  checksumType  = 'sha256'
  url64bit      = "https://s3.amazonaws.com/downloads.mirthcorp.com/connect-client-launcher/mirth-administrator-launcher-latest-windows-x64.exe"   # 64bit URL here (HTTPS preferred) or remove - if installer contains both architectures (very rare), use $url
  checksum64    = '35DF4BD913B7E9350D1269668EF7AEE764CACED32F73EAC93472C0362E627B8B'
  checksumType64= 'sha256'
  destination   = $toolsDir
}

Install-ChocolateyPackage @packageArgs
