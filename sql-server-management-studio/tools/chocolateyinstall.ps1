$ErrorActionPreference = 'Stop';

$release = '19.2'
$fullUrl = 'https://download.microsoft.com/download/6/2/6/626e40a7-449e-418d-9726-33b523a1e336/SSMS-Setup-ENU.exe'
$fullChecksum = 'C283FC904A7493839AEB26C4F9DF5E8F11D266C0B00666D9DCE50DBC5BDC49BC'

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  fileType      = 'EXE'
  silentArgs    = "/quiet /install /norestart /log `"$env:TEMP\chocolatey\$($env:ChocolateyPackageName)\$($env:ChocolateyPackageVersion)\SSMS.MsiInstall.log`""
  validExitCodes= @(0, 3010, 1641)
  softwareName  = "SQL Server Management Studio - $release"
}

$pp = Get-PackageParameters

if ($pp['SSMSExePath'])
{
    $packageArgs.file = $pp['SSMSExePath']

    Install-ChocolateyInstallPackage @packageArgs
}
else
{
    $packageArgs.url           = $fullUrl
    $packageArgs.checksum      = $fullChecksum
    $packageArgs.checksumType  = 'SHA256'

    Install-ChocolateyPackage @packageArgs
}
