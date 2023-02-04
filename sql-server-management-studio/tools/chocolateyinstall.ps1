$ErrorActionPreference = 'Stop';

$release = '19.0.1'
$fullUrl = 'https://download.microsoft.com/download/a/3/2/a32ae99f-b6bf-4a49-a076-e66503ccb925/SSMS-Setup-ENU.exe'
$fullChecksum = '5681DB7E7F6ACA0E579E2E07132E0C84756D1C696554A8C1E93B6EB506957140'

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
