﻿$ErrorActionPreference = 'Stop'; # stop on all errors

$platformPackageName = 'resharper-platform'
$packageName = 'ReSharper-Ultimate-All'
$scriptPath = $(Split-Path -parent $MyInvocation.MyCommand.Definition)
$commonPath = $(Split-Path -parent $(Split-Path -parent $scriptPath))
$filename = 'JetBrains.dotUltimate.2025.2.RC2.Checked.exe'
$installPath = Join-Path  (Join-Path $commonPath $platformPackageName) $filename
$packageParameters = Get-PackageParameters

$products = "ReSharper;dotTrace;dotMemory;dotCover;dotPeek"

if ($null -eq $packageParameters["NoCpp"]) {
  $products += ";ReSharperCpp"
}

if ($null -eq $packageParameters["NoTeamCityAddin"]) {
  $products += ";teamCityAddin"
}

$silentArgs = "/Silent=True /SpecificProductNames=$products /VsVersion=*"

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
  softwareName  = 'ReSharper'
}

Install-ChocolateyInstallPackage @packageArgs
