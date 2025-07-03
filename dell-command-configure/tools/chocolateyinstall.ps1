$ErrorActionPreference = 'Stop';
$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

# The dl.dell.com site seems to reject requests from the Chocolatey user agent, so prefer downloads.dell.com
$fileLocation = 'https://downloads.dell.com/FOLDER12902766M/1/Dell-Command-Configure-Application_MD8CJ_WIN64_5.2.0.9_A00.EXE'

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  softwareName   = 'Dell Command | Configure'
  file           = $fileLocation
  fileType       = 'exe'
  silentArgs     = "/s"
  
  validExitCodes = @(0)
  checksum       = 'ff4d5685036e4f2cfa9856d8cf16761ab098d369573e97ae944eb4555cd9341e'
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
