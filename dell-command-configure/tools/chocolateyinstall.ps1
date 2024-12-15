$ErrorActionPreference = 'Stop';
$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

# The dl.dell.com site seems to reject requests from the Chocolatey user agent, so prefer downloads.dell.com
$fileLocation = 'https://downloads.dell.com/FOLDER12092620M/1/Dell-Command-Configure-Application_H0D62_WIN_5.0.0.48_A00.EXE'

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  softwareName   = 'Dell Command | Configure'
  file           = $fileLocation
  fileType       = 'exe'
  silentArgs     = "/s"
  
  validExitCodes = @(0)
  checksum       = 'd7e291205369ffaaa3bdf2faf5c89922930a69324730a7dade30b73113e36fed'
  checksumType   = 'sha256'
  destination    = $toolsDir
}

Install-ChocolateyPackage @packageArgs

# Remove desktop shortcut (unfortunately there is no way to disable desktop icon in installer)
$pp = Get-PackageParameters

if ($pp['RemoveDesktopShortcut']) {
  $sharedDesktop = [System.Environment]::GetFolderPath([Environment+SpecialFolder]::CommonDesktopDirectory)
  Remove-Item "$sharedDesktop\Dell Command Configure Wizard.lnk" -Force -ErrorAction SilentlyContinue
}
