$ErrorActionPreference = 'Stop';

$release = '18.9.1'
$fullUrl = 'https://download.microsoft.com/download/4/6/8/4681f3b2-f327-4d3d-8617-264b20685be0/SSMS-Setup-ENU.exe'
$fullChecksum = 'CE12A64F066DF907FB62077E5D22A8C5312893664212CCA4660D8EBEEE2F59C6'

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
