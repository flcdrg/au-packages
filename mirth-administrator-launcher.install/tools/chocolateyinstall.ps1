$ErrorActionPreference = 'Stop';
$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  softwareName  = 'Mirth Connect Administrator Launcher *'
  fileType      = 'exe'
  silentArgs    = "-q -console"
  
  validExitCodes= @(0) #please insert other valid exit codes here
  url           = "https://s3.us-east-1.amazonaws.com/downloads.mirthcorp.com/connect-client-launcher/mirth-administrator-launcher-1.4.1-windows-x32.exe"  #download URL, HTTPS preferrred
  checksum      = 'b611b31cd1532fe0d34264f625a0e6777f2d71f8d9a990248e231efe2b48f1b1'
  checksumType  = 'sha256'
  url64bit      = "https://s3.us-east-1.amazonaws.com/downloads.mirthcorp.com/connect-client-launcher/mirth-administrator-launcher-1.4.1-windows-x64.exe"   # 64bit URL here (HTTPS preferred) or remove - if installer contains both architectures (very rare), use $url
  checksum64    = '38f05393bbb0ac35da8af615dc25c7760577cec960338b9283e5e1ca9f5643bb'
  checksumType64= 'sha256'
  destination   = $toolsDir
}

Install-ChocolateyPackage @packageArgs
