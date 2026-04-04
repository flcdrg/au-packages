$ErrorActionPreference = 'Stop';
$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$url = 'https://download.red-gate.com/installers/SQLToolbelt/2026-04-02/SQLToolbelt.exe'
$checksum = '1FCF3EAB2C7C0850D6F35E49EC5B7865411D85FF38D49B5AFFE2960AEF48728A'

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
