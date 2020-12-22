$ErrorActionPreference = 'Stop';

$release = '18.8'
$fullUrl = 'https://download.microsoft.com/download/3/f/d/3fd533f5-fdfc-407d-98a6-d5deb214d13b/SSMS-Setup-ENU.exe'
$fullChecksum = 'FF66A03370776E7E44CCC3207A1A39FB49FB89A63C1F50914B1E0C9F6C11358C'

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
