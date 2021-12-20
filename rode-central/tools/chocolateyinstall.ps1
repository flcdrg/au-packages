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
  checksum      = '47331C73BE64B0655D4DB2AE52452A108D440B7BC7A6A7837B26BD50ECA4F17B'
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
  file          = "$toolsDir\RODE Central (1.3.5)_WINDOWS\RODE Central (1.3.5).msi"
}

Install-ChocolateyInstallPackage @packageArgs