$ErrorActionPreference = 'Stop';
$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$url = 'https://download.red-gate.com/installers/SQLToolbelt/2022-03-21/SQLToolbelt.exe'
$checksum = '797E4AD1F7904845CE61EEF79B32DC25B4F47D7EF77D5860A02D2431E03B74B5'

$validProductPackageNames = @(
  "SQL Compare",
  "SQL Data Compare",
  "SQL Source Control",
  "SQL Prompt",
  "SQL Search",
  "SQL Data Generator",
  "SQL Doc",
  "SQL Test",
  "DLM Dashboard",
  "SQL Multi Script",
  "SQL Dependency Tracker",
  "SQL Monitor Installer",
  "SQL Backup",
  "SSMS Integration Pack",
  "SQL Change Automation Powershell",
  "SQL Change Automation" )

$pp = Get-PackageParameters

$commandArgs = ""
if ($pp["products"] -ne $null -and $pp["products"] -ne ''){

  $products = $pp["products"].Split(",")
  foreach($product in $products){
    if(!$validProductPackageNames.Contains($product.Trim())){
      throw "Invalid product package name '$product', exiting installer."
    }
  }

  $productCommand = "products ""$($pp["products"])"""
  $commandArgs += "$productCommand "
} else {

  $productCommand = "all products"
}

$commandArgs += "/IAgreeToTheEula"

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  fileType      = 'exe'
  silentArgs    = $commandArgs

  validExitCodes= @(0)
  url           = $url
  checksum      = $checksum
  checksumType  = 'sha256'
  destination   = $toolsDir
}

Install-ChocolateyPackage @packageArgs
