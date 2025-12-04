$ErrorActionPreference = 'Stop';
$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$url = 'https://dl.dell.com/FOLDER13914977M/1/Dell-Command-Configure-Application_5RNW8_WIN64_5.2.1.16_A00.EXE'

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  softwareName   = 'Dell Command | Configure'
  url            = $url
  File           = [IO.Path]::Combine($toolsDir, [IO.Path]::GetFileName($url))
  fileType       = 'exe'
  silentArgs     = "/s"
  validExitCodes = @(0)
  checksum       = '521fafc70f7f587b49b3f48ccd5fd24474320a43f34acdf4cc6a72ed22a1e648'
  checksumType   = 'sha256'
  UserAgent      = 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.3'
}

# Dell check user-agents on that URL (and doesn't like Chocolatey's default one), 
# and because of https://github.com/chocolatey/choco/issues/3191
# we can't override the user agent when calling Install-ChocolateyPackage.
# So we resort to doing the download and checksum verification ourselves.
Get-WebFile @packageArgs

Get-ChecksumValid @packageArgs

Install-ChocolateyInstallPackage @packageArgs

# Remove desktop shortcut (unfortunately there is no way to disable desktop icon in installer)
$pp = Get-PackageParameters

if ($pp['RemoveDesktopShortcut']) {
  $sharedDesktop = [System.Environment]::GetFolderPath([Environment+SpecialFolder]::CommonDesktopDirectory)
  Remove-Item "$sharedDesktop\Dell Command Configure Wizard.lnk" -Force -ErrorAction SilentlyContinue
}
