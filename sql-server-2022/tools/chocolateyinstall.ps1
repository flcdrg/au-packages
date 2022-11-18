$ErrorActionPreference = 'Stop'; # stop on all errors
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url        = 'https://download.microsoft.com/download/3/8/d/38de7036-2433-4207-8eae-06e247e17b25/SQLServer2022-x64-ENU-Dev.iso'

. $toolsDir\Get-PendingReboot.ps1

if ([Version] (Get-CimInstance Win32_OperatingSystem).Version -lt [version] "10.0.0.0") {
  Write-Error "SQL Server 2022 requires a minimum of Windows 10 or Windows Server 2016"
}

$pp = Get-PackageParameters

if ( (!$pp['IGNOREPENDINGREBOOT']) -and (Get-PendingReboot).RebootPending) {
  Write-Error "A system reboot is pending. You must restart Windows first before installing SQL Server"
} else {
  if ($pp['IGNOREPENDINGREBOOT']) {
    $pp.Remove('IGNOREPENDINGREBOOT')
    if(!$pp['ACTION']) {
      $pp['ACTION']='Install'
    }
    if(!$pp['SkipRules']) {
      $pp['SkipRules']='RebootRequiredCheck'
    }
  }
}

# Default to use supplied configuration file and current user as sysadmin
if (!$pp['CONFIGURATIONFILE']) {
  $pp['CONFIGURATIONFILE'] = "$toolsDir\ConfigurationFile.ini"
}

if (!$pp['SQLSYSADMINACCOUNTS']) {
  # Test for presence of "^SQLSYSADMINACCOUNTS=" in the ini - add the default only if not present
  if (-not ((Get-Content -Path $($pp['CONFIGURATIONFILE'])) -match "^SQLSYSADMINACCOUNTS=")) {
    $pp['SQLSYSADMINACCOUNTS'] = "$env:USERDOMAIN\$env:USERNAME"
  }
}

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName

  fileType      = 'EXE'
  url           = $url

  softwareName  = 'Microsoft SQL Server 2022 (64-bit)'
  checksum      = '80D2CD75DD2B28098C0182F50AD86BD44F9B3A9F357C30FF617480A1497DAFFD'
  checksumType  = 'sha256'

  silentArgs   = "/IAcceptSqlServerLicenseTerms /Q "
  validExitCodes= @(0, 3010)
}

# Download if we don't have an existing .iso
if (!$pp['IsoPath']) {

  $chocTempDir = $env:TEMP
  $tempDir = Join-Path $chocTempDir "$($env:chocolateyPackageName)"
  if ($env:chocolateyPackageVersion -ne $null) {
     $tempDir = Join-Path $tempDir "$($env:chocolateyPackageVersion)";
  }

  $tempDir = $tempDir -replace '\\chocolatey\\chocolatey\\', '\chocolatey\'
  if (![System.IO.Directory]::Exists($tempDir)) {
    [System.IO.Directory]::CreateDirectory($tempDir) | Out-Null
  }

  $fileFullPath = Join-Path $tempDir "SQLServer2022-x64-ENU-Dev.iso"
  Get-ChocolateyWebFile @packageArgs -FileFullPath $fileFullPath
} else {
  $fileFullPath = $pp['IsoPath']
  $pp.Remove("IsoPath")
}

# append remaining package parameters
$packageArgs.silentArgs += ($pp.GetEnumerator() | ForEach-Object { "/$($_.name)=`"$($_.value)`"" }) -join " "

try {
  $MountResult = Mount-DiskImage -ImagePath $fileFullPath -StorageType ISO -PassThru
  $MountVolume = $MountResult | Get-Volume
  $MountLocation = "$($MountVolume.DriveLetter):"

  Install-ChocolateyInstallPackage @packageArgs -File "$($MountLocation)\setup.exe"
}
finally {
  Dismount-DiskImage -ImagePath $fileFullPath
}
