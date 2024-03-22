$ErrorActionPreference = 'Stop';

$release = '20.0'
$fullUrl = 'https://download.microsoft.com/download/1/b/c/1bc1f462-ac3a-402d-b872-c4cae745c539/SSMS-Setup-ENU.exe'
$fullChecksum = 'FBC7C433ED9282772D2E9B2E9FCDB10509BBD82EB80359F6C0F8289D01B38C91'

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
