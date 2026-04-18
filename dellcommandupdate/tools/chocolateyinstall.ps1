$ErrorActionPreference = 'Stop';

$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url = 'https://dl.dell.com/FOLDER14424243M/1/Dell-Command-Update-Application_RXT5N_WIN64_5.7.0_A00.EXE'
$checksum = 'b6d0d06edf25a7d9092208b2686502e031deda5ccb2d283ba8a434b27891f3cf'
$checksumType = 'sha256'

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  softwareName   = 'Dell Command | Update'
  File           = [IO.Path]::Combine($toolsDir, [IO.Path]::GetFileName($url))
  fileType       = 'exe'
  silentArgs     = "/s"
  validExitCodes = @(0)
  url            = $url
  checksum       = $checksum
  checksumType   = $checksumType
  UserAgent      = 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.3'
}

# Install-ChocolateyPackage @packageArgs

# As Dell have decommissioned downloads.dell.com we're forced to use dl.dell.com instead.
# BUT Dell check user-agents on that URL (and doesn't like Chocolatey's default one), 
# and because of https://github.com/chocolatey/choco/issues/3191
# we can't override the user agent when calling Install-ChocolateyPackage.
# So we resort to doing the download and checksum verification ourselves.
Get-WebFile @packageArgs

Get-ChecksumValid @packageArgs

Install-ChocolateyInstallPackage @packageArgs
