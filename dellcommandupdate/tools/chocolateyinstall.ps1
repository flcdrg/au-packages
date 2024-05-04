$ErrorActionPreference = 'Stop';

$packageName  = 'dellcommandupdate'
$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url = 'https://downloads.dell.com/FOLDER11563430M/1/Dell-Command-Update-Application_T45GH_WIN_5.3.0_A00.EXE'
$checksum = '6c38dca6d65eaa32cb5b70e665e41f549330d139bfa1f07890bec6a9cd57ff18'
$checksumType = 'sha256'

$packageArgs = @{
  packageName   = $packageName
  softwareName  = 'Dell Command | Update'
  fileType      = 'exe'
  silentArgs    = "/s"
  validExitCodes= @(0)
  url           = $url
  checksum      = $checksum
  checksumType  = $checksumType
  destination   = $toolsDir
  options       = @{ Headers = @{ 'User-Agent' = 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:122.0) Gecko/20100101 Firefox/122.0' } }
}

Install-ChocolateyPackage @packageArgs 
