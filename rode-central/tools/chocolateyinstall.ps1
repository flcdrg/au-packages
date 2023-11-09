$ErrorActionPreference = 'Stop';
$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$checksum = '3CE5C98AF351A2BC5B8B3A2DE6AB2D800BD5878614201FE572321FC235477850';
$relativePath = 'RODE Central (2.0.38).msi';


if ([Version] (Get-CimInstance Win32_OperatingSystem).Version -lt [version] "10.0.17134.0") {
  Write-Warning "RODE Central requires Windows 10 1803 or later"
}

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  softwareName  = 'RODE Central*'
  fileType      = 'zip'
  silentArgs    = "/s"
  
  validExitCodes= @(0)
  url           = "https://update.rode.com/central/RODE_Central_WIN.zip"
  checksum      = $checksum
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
  file          = [IO.Path]::Combine($toolsDir, $relativePath)
}

Install-ChocolateyInstallPackage @packageArgs
