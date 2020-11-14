$ErrorActionPreference = 'Stop';

$release = '18.7.1'
$fullUrl = 'https://download.microsoft.com/download/2/d/1/2d12f6a1-e28f-42d1-9617-ac036857c5be/SSMS-Setup-ENU.exe'
$fullChecksum = '27FBEAD01257513F87C619765C06611B2F4F53C7C6C2B9F1DC3EDF3ACE14295D'

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
