$ErrorActionPreference = 'Stop'; # stop on all errors

$platformPackageName = 'resharper-platform'
$packageName = 'dotUltimate'
$scriptPath = $(Split-Path -parent $MyInvocation.MyCommand.Definition)
$commonPath = $(Split-Path -parent $(Split-Path -parent $scriptPath))
$filename = 'JetBrains.dotUltimate.2025.2.EAP7.Checked.exe'
$installPath = Join-Path  (Join-Path $commonPath $platformPackageName) $filename
$packageParameters = Get-PackageParameters

$products = @()

if ($null -eq $packageParameters["NoReSharper"]) {
  $products += "ReSharper"
}

if ($null -eq $packageParameters["NoDotTrace"]) {
  $products += "dotTrace"
}

if ($null -eq $packageParameters["NoDotMemory"]) {
  $products += "dotMemory"
}

if ($null -eq $packageParameters["NoDotCover"]) {
  $products += "dotCover"
}

if ($null -eq $packageParameters["NoDotPeek"]) {
  $products += "dotPeek"
}

if ($null -eq $packageParameters["NoCpp"]) {
  $products += "ReSharperCpp"
}

if ($null -eq $packageParameters["NoTeamCityAddin"]) {
  $products += "teamCityAddin"
}

if ($null -eq $packageParameters["NoRider"]) {
  $products += "Rider"
}

$silentArgs = "/Silent=True /SpecificProductNames=$($products -join ';') /VsVersion=*"

Write-Verbose $silentArgs

if ($packageParameters["PerMachine"]) {
  $silentArgs += " /PerMachine=True"
}


$packageArgs = @{
  packageName   = $packageName
  fileType      = 'exe'
  file          = $installPath
  silentArgs    = $silentArgs
  validExitCodes= @(0)
  softwareName  = 'ReSharper'
}

Install-ChocolateyInstallPackage @packageArgs
