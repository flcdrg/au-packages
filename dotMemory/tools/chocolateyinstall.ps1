$ErrorActionPreference = 'Stop'; # stop on all errors

$filename = 'JetBrains.dotUltimate.2025.2.2.exe'

$platformPackageName = 'resharper-platform'

$scriptPath = $(Split-Path -parent $MyInvocation.MyCommand.Definition)
$commonPath = $(Split-Path -parent $(Split-Path -parent $scriptPath))
$installPath = Join-Path  (Join-Path $commonPath $platformPackageName) $filename

$packageParameters = Get-PackageParameters

$silentArgs = "/Silent=True /SpecificProductNames=dotMemory /VsVersion=*"

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
  softwareName  = $env:ChocolateyPackageName
}
Install-ChocolateyInstallPackage @packageArgs
