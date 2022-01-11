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
  checksum      = 'BAE1AED9917557F0D7FEFEE4BC9CC39456C9B4AB7095779E2F0224B08E0FE731'
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
  file          = "$toolsDir\RODE Central Windows v1.3.6\RODE Central (1.3.6).msi"
}

Install-ChocolateyInstallPackage @packageArgs