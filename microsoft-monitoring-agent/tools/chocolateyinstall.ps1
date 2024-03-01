$ErrorActionPreference = 'Stop';
$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$url32      = 'https://download.microsoft.com/download/e/5/b/e5b8085f-a711-469b-9453-7596a31099cc/MMASetup-i386.exe'
$checksum32 = '4EE16A77CD5D303F2A678877A75621CFFCB3607779FB7349DC9FC4D868CC045E'
$url64      = 'https://download.microsoft.com/download/f/6/3/f630608f-5905-4390-b2bf-36f509214022/MMASetup-AMD64.exe'
$checksum64 = '9AD3E188C219E469D4210B25AD4CBD6CCF506E936855BEE4277DFB87BE8D0096'

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
