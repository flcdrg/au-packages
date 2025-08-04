$ErrorActionPreference = 'Stop';
$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  softwareName  = 'OSCAR'
  fileType      = 'exe'

  silentArgs   = '/VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-'
  
  validExitCodes= @(0) #please insert other valid exit codes here
  url           = "https://www.apneaboard.com/OSCAR/1.6.1/OSCAR-1.6.1-Win32.exe"
  checksum      = '5F85D3862167D198EC5192B024A588DE0E9B147F4D74B7EA1E0BC0EBB98895F8'
  checksumType  = 'sha256'
  url64bit      = "https://www.apneaboard.com/OSCAR/1.6.1/OSCAR-1.6.1-Win64.exe"
  checksum64    = '93304BD9B445738E96B3ACC97FC3ABA8A1200FB9BCE9D9B79A6C67E32D65BFF8'
  checksumType64= 'sha256'
  destination   = $toolsDir
}

Install-ChocolateyPackage @packageArgs
