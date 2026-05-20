$ErrorActionPreference = 'Stop';
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url        = 'https://github.com/VirusTotal/vt-cli/releases/download/1.3.1/Windows32.zip'
$url64      = 'https://github.com/VirusTotal/vt-cli/releases/download/1.3.1/Windows64.zip'
$checksum   = 'a9f52f8f99b03144d4245d9cd82f64850630410a5d185b04e1b5b67ca1befcdd'
$checksum64 = '0b355668acbd181b2b8d9a04bcf70853616fb7a96f41491243b8daaa077da947'

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  unzipLocation = $toolsDir
  url           = $url
  url64bit      = $url64
  softwareName  = 'vt-cli*'
  checksum      = $checksum
  checksumType  = 'sha256'
  checksum64    = $checksum64
  checksumType64= 'sha256'
}

Install-ChocolateyZipPackage @packageArgs
