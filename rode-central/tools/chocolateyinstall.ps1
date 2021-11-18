$ErrorActionPreference = 'Stop';
$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"


if ([Version] (Get-CimInstance Win32_OperatingSystem).Version -lt [version] "10.0.17134.0") {
  Write-Warning "RODE Central requires Windows 10 1803 or later"
}

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  softwareName  = 'RODE Central*'
  fileType      = 'zip'
  silentArgs    = "/s"
  
  validExitCodes= @(0)
  url           = "https://cdn1.rode.com/rodecentral_installation_file_windows.zip"
  checksum      = 'BA598A1E691C0BEC9185C98377925DA6ECFE7487B6AD8D466D749BCE08B66FB2'
  checksumType  = 'sha256'
  UnzipLocation = $toolsDir
}

# Download file and unzip into tools dir
Install-ChocolateyZipPackage @packageArgs

# Install MSI
$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  fileType      = 'msi'
  silentArgs    = '/q'
  validExitCodes= @(0)
  # This seems like a bug. Maybe the brackets are confusing 7z or Chocolatey
  file          = "$toolsDir\RodeCentral_installers_windows\RODE Central Installer 1.2.4 (Windows).msi"
}

Install-ChocolateyInstallPackage @packageArgs