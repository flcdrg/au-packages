$ErrorActionPreference = 'Stop';

$release = '18.10'
$fullUrl = 'https://download.microsoft.com/download/a/2/e/a2ef0390-62b6-4189-af6d-1762e0aa90aa/SSMS-Setup-ENU.exe'
$fullChecksum = '3D99CB9FC78F50655498063F94C5BBE063289AF5ECBF43DB352FDC634730C5D8'

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
