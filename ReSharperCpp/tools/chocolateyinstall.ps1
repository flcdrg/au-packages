$ErrorActionPreference = 'Stop'; # stop on all errors

$filename = 'JetBrains.dotUltimate.2024.3.EAP3.Checked.exe'

$platformPackageName = 'resharper-platform'

$scriptPath = $(Split-Path -parent $MyInvocation.MyCommand.Definition)
$commonPath = $(Split-Path -parent $(Split-Path -parent $scriptPath))
$installPath = Join-Path  (Join-Path $commonPath $platformPackageName) $filename
$packageParameters = Get-PackageParameters

$silentArgs = "/Silent=True /SpecificProductNames=ReSharperCpp /VsVersion=*"

if ($packageParameters["PerMachine"]) {
  $silentArgs += " /PerMachine=True"
}

Write-Verbose $silentArgs

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  fileType      = 'exe'
  file          = $installPath
  silentArgs    = $silentArgs
  validExitCodes= @(0)
  softwareName  = 'ReSharper C++'
}
Install-ChocolateyInstallPackage @packageArgs
