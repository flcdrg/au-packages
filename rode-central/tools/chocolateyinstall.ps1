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
  checksum      = 'DD7A0888E5BACB1E693026C993758185451D4998D4FA420845D18C0B7F5ED805'
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
  file          = "$toolsDir\RODE Central Windows (1.2.1).msi"
}

Install-ChocolateyInstallPackage @packageArgs