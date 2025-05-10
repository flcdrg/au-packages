$ErrorActionPreference = 'Stop';
$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  softwareName   = 'NDI 6 Runtime'
  fileType       = 'exe'
  silentArgs     = "/VERYSILENT /LOG /NORESTART /SUPPRESSMSGBOXES"
  
  validExitCodes = @(0)
  url            = "http://ndi.link/NDIRedistV6"
  checksum       = '1466F6FE42A585D0906D146D820DEE87B694C0DF5986888AFC0A939B9708AC3A'
  checksumType   = 'sha256'
  destination    = $toolsDir
}

Install-ChocolateyPackage @packageArgs
