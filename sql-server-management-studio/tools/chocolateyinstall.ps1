$ErrorActionPreference = 'Stop';

$release = '19.0.2'
$fullUrl = 'https://download.microsoft.com/download/9/f/8/9f8197f4-0f71-42a3-8717-b2817c77b820/SSMS-Setup-ENU.exe'
$fullChecksum = '7227D0A979BFC2ACF07EB0FD710E58A7D046B112C3B6ABE9BB87490A0432AECB'

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
