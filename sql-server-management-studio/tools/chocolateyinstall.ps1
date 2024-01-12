$ErrorActionPreference = 'Stop';

$release = '19.3'
$fullUrl = 'https://download.microsoft.com/download/7/7/3/7738e337-ed99-40ea-b8ae-f639162c83c3/SSMS-Setup-ENU.exe'
$fullChecksum = 'AFD3A8F6AABF903845BC7866D2650C83D47F659F480BB71453F74A8DED8010F7'

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
