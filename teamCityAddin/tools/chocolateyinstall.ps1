$platformPackageName = 'resharper-platform'
$packageName = 'teamCityAddin'
$scriptPath = $(Split-Path -parent $MyInvocation.MyCommand.Definition)
$commonPath = $(Split-Path -parent $(Split-Path -parent $scriptPath))
$filename = 'JetBrains.dotUltimate.2023.2.exe'

$installPath = Join-Path  (Join-Path $commonPath $platformPackageName) $filename
$packageParameters = Get-PackageParameters

$silentArgs = "/Silent=True /SpecificProductNames=teamCityAddin /VsVersion=*"

if ($packageParameters["PerMachine"]) {
  $silentArgs += " /PerMachine=True"
}

Write-Verbose $silentArgs

$packageArgs = @{
  packageName   = $packageName
  fileType      = 'exe'
  file          = $installPath
  silentArgs    = $silentArgs
  validExitCodes= @(0)
  softwareName  = 'TeamCity Add-in'
}
Install-ChocolateyInstallPackage @packageArgs
