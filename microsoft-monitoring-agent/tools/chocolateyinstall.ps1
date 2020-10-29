$ErrorActionPreference = 'Stop';
$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$url32      = 'https://download.microsoft.com/download/e/5/f/e5f902ff-7718-4b47-bc54-b1f9cbe3054f/MMASetup-i386.exe'
$checksum32 = '7073FD568A1CBC565DAAC89407259B03E36022BA68F882C97B6F1D88761A6CEC'
$url64      = 'https://download.microsoft.com/download/3/c/d/3cd6f5b3-3fbe-43c0-88e0-8256d02db5b7/MMASetup-AMD64.exe'
$checksum64 = '6EF939A9CF03533B371D0B4FF8DC76615E1A12C740ACE9F30D887CEBB9C5DE4D'

# package parameters
$pp = Get-PackageParameters

if ($pp['WorkspaceId'] -and $pp['WorkspaceKey']) {
  $azureArgs = "ADD_OPINSIGHTS_WORKSPACE=1 OPINSIGHTS_WORKSPACE_ID=$($pp['WorkspaceId']) OPINSIGHTS_WORKSPACE_KEY=$($pp['WorkspaceKey'])"
  Write-Verbose "Configuring with Azure Monitor workspace"
} elseif ($pp['WorkspaceId'] -or $pp['WorkspaceKey']) {
  throw "Both WorkspaceId and WorkspaceKey package parameters must be supplied"
} else {
  Write-Host "Installing agent, but configuration will need to be done via Control Panel app"
}

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  softwareName  = 'Microsoft Monitoring Agent'
  fileType      = 'exe'

  # https://github.com/MicrosoftDocs/azure-docs/issues/29171
  # https://docs.microsoft.com/en-us/azure/azure-monitor/platform/agent-windows#install-the-agent-using-the-command-line
  silentArgs    = "/C:`"setup.exe /qn NOAPM=1 $azureArgs AcceptEndUserLicenseAgreement=1`""
  
  validExitCodes= @(0) #please insert other valid exit codes here
  url           = $url32
  checksum      = $checksum32
  checksumType  = 'sha256'
  url64bit      = $url64
  checksum64    = $checksum64
  checksumType64= 'sha256'
  destination   = $toolsDir
}

Install-ChocolateyPackage @packageArgs
