﻿$ErrorActionPreference = 'Stop';
$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url = 'https://download.microsoft.com/download/1/0/5/1059800B-F375-451C-B37E-758FFC7C8C8B/WindowsAdminCenter2103.2.msi'
$checksum = '951E83914C129BB9048B4355851DDEEDE2B579E26679A5A19814FBF7F6CC8C35'

$pp = Get-PackageParameters

# Defaults
$port = 6516
$certificateOption = "generate"
$thumbprint = ""

if ($pp['PORT']) {
  $port = [int] $pp['PORT']
}

if ($pp['THUMBPRINT']) {
  $certificateOption = "installed"
  $thumbprint = "SME_THUMBPRINT=$($pp['THUMBPRINT'])"
}

# http://aka.ms/WACDownload
$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  softwareName  = 'Windows Admin Center'
  fileType      = 'msi'
  silentArgs    = "/qn /norestart SME_PORT=$port SSL_CERTIFICATE_OPTION=$certificateOption $thumbprint /l*v `"$($env:TEMP)\$($packageName).$($env:chocolateyPackageVersion).MsiInstall.log`"" # ALLUSERS=1 DISABLEDESKTOPSHORTCUT=1 ADDDESKTOPICON=0 ADDSTARTMENU=0
  validExitCodes= @(0, 3010, 1641)
  url           = $url
  checksum      = $checksum
  checksumType  = 'sha256'
  destination   = $toolsDir
}

Install-ChocolateyPackage @packageArgs
