$ErrorActionPreference = 'Stop';

$release = '18.9.2'
$fullUrl = 'https://download.microsoft.com/download/1/e/c/1ec92162-142d-4fed-a575-6e2195b65a66/SSMS-Setup-ENU.exe'
$fullChecksum = '03E567B7475EC2E2DA237D70E9A833DEABF52CA66D521F340A1EBC8FDEA91170'

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
