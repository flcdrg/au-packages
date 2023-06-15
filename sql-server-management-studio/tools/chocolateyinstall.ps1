$ErrorActionPreference = 'Stop';

$release = '19.1'
$fullUrl = 'https://download.microsoft.com/download/a/c/a/aca4e29f-6925-4d50-a06b-5576c6ea629f/SSMS-Setup-ENU.exe'
$fullChecksum = 'FDC2CE3EA167882874B26D06796FE2DC21DE03394E6D3F72ACD28F0836C9FF9E'

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
