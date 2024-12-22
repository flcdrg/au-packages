$ErrorActionPreference = 'Stop';
$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

# The dl.dell.com site seems to reject requests from the Chocolatey user agent, so prefer downloads.dell.com
$fileLocation = 'https://downloads.dell.com/FOLDER12409577M/4/Dell-Command-Configure-Application_438RH_WIN64_5.0.1.3_A00.EXE'

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  softwareName   = 'Dell Command | Configure'
  file           = $fileLocation
  fileType       = 'exe'
  silentArgs     = "/s"
  
  validExitCodes = @(0)
  checksum       = '997652aa18fa17be7c418b288a0f783f58694f0f2a972410c055dea83a1fa67f'
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
