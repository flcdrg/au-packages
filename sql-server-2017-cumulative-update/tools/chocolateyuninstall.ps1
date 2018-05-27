﻿$ErrorActionPreference = 'Stop';
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$file = Join-Path $toolsDir "SQLServer2017-KB4052987-x64.exe"

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  softwareName  = 'sql-server-2017-cumulative-update*'
  fileType      = 'EXE'
  file          = $file
  silentArgs    = "/q /IAcceptSQLServerLicenseTerms /Action=RemovePatch /AllInstances"
  validExitCodes= @(0, 3010, 1605, 1614, 1641)
}

Uninstall-ChocolateyPackage @packageArgs

[array]$key = Get-UninstallRegistryKey -SoftwareName $packageArgs['softwareName']

if ($key.Count -eq 1) {
  $key | ForEach-Object { 
    $packageArgs['file'] = "$($_.UninstallString)"
    if ($packageArgs['fileType'] -eq 'MSI') {
      $packageArgs['silentArgs'] = "$($_.PSChildName) $($packageArgs['silentArgs'])"
      $packageArgs['file'] = ''
    }

    Uninstall-ChocolateyPackage @packageArgs
  }
} elseif ($key.Count -eq 0) {
  Write-Warning "$packageName has already been uninstalled by other means."
} elseif ($key.Count -gt 1) {
  Write-Warning "$($key.Count) matches found!"
  Write-Warning "To prevent accidental data loss, no programs will be uninstalled."
  Write-Warning "Please alert package maintainer the following keys were matched:"
  $key | ForEach-Object {Write-Warning "- $($_.DisplayName)"}
}