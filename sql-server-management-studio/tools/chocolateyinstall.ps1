$ErrorActionPreference = 'Stop';

$release = '18.7.1'
$packageName= 'SQL Server Management Studio'
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$fileType = 'EXE'
$args = "/quiet /install /norestart /log `"$env:TEMP\chocolatey\$($env:ChocolateyPackageName)\$($env:ChocolateyPackageVersion)\SSMS.MsiInstall.log`""
$exitCodes = @(0, 3010, 1641)
$softwareName = "SQL Server Management Studio - $release"

$pp = Get-PackageParameters

if ($pp['SSMSExePath'])
{
    $packageArgs = @{
      packageName   = $packageName
      unzipLocation = $toolsDir
      fileType      = $fileType
      file          = $params['SSMSExePath']
      silentArgs    = $args
      validExitCodes= $exitCodes
      softwareName  = $softwareName
    }
    
    Install-ChocolateyInstallPackage @packageArgs
}
else
{
    $fullUrl = 'https://download.microsoft.com/download/2/d/1/2d12f6a1-e28f-42d1-9617-ac036857c5be/SSMS-Setup-ENU.exe'
    $fullChecksum = '27FBEAD01257513F87C619765C06611B2F4F53C7C6C2B9F1DC3EDF3ACE14295D'

    # Upgrading is commented out for 18.x until the first upgrade package is made available by Microsoft

    # $upgradeUrl = 'https://download.microsoft.com/download/D/D/4/DD495084-ADA7-4827-ADD3-FC566EC05B90/SSMS-Setup-ENU-Upgrade.exe'
    # $upgradeChecksum = 'A092B5F4270F19B83874E8ECDEC8EF309B8DBC55462E99EAFA309A75A1D04E09'   

    # Check if 17.0 is installed so we can get upgrade package instead of full package
    # $version17 = [version]"14.0.17099.0"
    $ssms180 = $false # Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* | Select-Object DisplayName, DisplayVersion | Where-Object { $_.DisplayName -eq "SQL Server Management Studio" -and ([Version]$_.DisplayVersion) -ge $version17 }

    $packageArgs = @{
      packageName   = $packageName
      unzipLocation = $toolsDir
      fileType      = $fileType
      url           = ''
      silentArgs    = $args
      validExitCodes= $exitCodes
      softwareName  = $softwareName
      checksum      = ''
      checksumType  = 'SHA256'
    }

    if ($ssms180) {
        Write-Warning "Existing install found, using upgrade installer"
        $packageArgs.url = $upgradeUrl
        $packageArgs.checksum = $upgradeChecksum
    } else {
        $packageArgs.url = $fullUrl
        $packageargs.checksum = $fullChecksum
    }

    Install-ChocolateyPackage @packageArgs
}
