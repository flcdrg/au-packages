$ErrorActionPreference = 'Stop';
$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

# The dl.dell.com site seems to reject requests from the Chocolatey user agent, so prefer downloads.dell.com
$fileLocation = 'https://downloads.dell.com/FOLDER11549484M/2/Dell-Command-Configure_H16FW_WIN_4.12.0.95_A00_01.EXE'

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  softwareName   = 'Dell Command | Configure'
  file           = $fileLocation
  fileType       = 'exe'
  silentArgs     = "/s"
  
  validExitCodes = @(0)
  checksum       = '41FF968F0FF4B67FFF2A8ABB89B61F9380AF798802FA714234DF3F1887CF6BFD'
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
