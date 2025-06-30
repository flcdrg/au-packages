$ErrorActionPreference = 'Stop';
$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$checksum = 'A9EED1D1FFA4758D2164E0E19D6A0E27160055BC3A3F0D4B2A65BAE856BCC932';
$relativePath = 'RODE Central (2.0.100-206).msi';


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
