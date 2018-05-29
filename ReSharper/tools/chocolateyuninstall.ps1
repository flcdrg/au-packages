$ErrorActionPreference = 'Stop'; # stop on all errors

$filename = "JetBrains.ReSharperUltimate.$($env:ChocolateyPackageVersion).exe"

$platformPackageName = 'resharper-platform'

$scriptPath = $(Split-Path -parent $MyInvocation.MyCommand.Definition)
$commonPath = $(Split-Path -parent $(Split-Path -parent $scriptPath))
$installPath = Join-Path  (Join-Path $commonPath $platformPackageName) $filename
Uninstall-ChocolateyPackage $env:ChocolateyPackageName 'exe' '/Silent=True /SpecificProductNamesToRemove=ReSharper /VsVersion=*' $installPath
