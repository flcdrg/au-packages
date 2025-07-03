$ErrorActionPreference = 'Stop';
$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$url = 'https://dl.dell.com/FOLDER12902766M/1/Dell-Command-Configure-Application_MD8CJ_WIN64_5.2.0.9_A00.EXE'

$packageArgs = @{
  packageName    = $env:ChocolateyPackageName
  softwareName   = 'Dell Command | Configure'
  url            = $url
  File           = [IO.Path]::Combine($toolsDir, [IO.Path]::GetFileName($url))
  fileType       = 'exe'
  silentArgs     = "/s"
  validExitCodes = @(0)
  checksum       = 'ff4d5685036e4f2cfa9856d8cf16761ab098d369573e97ae944eb4555cd9341e'
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
