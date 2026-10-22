$ErrorActionPreference = 'Stop';
$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$checksum = 'F0C6E53F2422B78BA34447C2E398BB22CA0C002633CD4E3D41AD0402E78C7861';
$relativePath = 'RODEConnect_Full (1.3.48).msi';


if ([Version] (Get-CimInstance Win32_OperatingSystem).Version -lt [version] "10.0.17134.0") {
  Write-Warning "RODE Connect requires Windows 10 1803 or later"
}

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  softwareName  = 'RODE Connect*'
  fileType      = 'zip'
  silentArgs    = "/s"
  
  validExitCodes= @(0)
  url           = "https://update.rode.com/connect/RODE_Connect_WIN.zip"
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
