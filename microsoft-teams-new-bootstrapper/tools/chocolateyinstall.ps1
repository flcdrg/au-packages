$ErrorActionPreference = 'Stop';
$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$minimumOsVersion = "10.0.19041" # 20H1
$osVersion = (Get-CimInstance Win32_OperatingSystem).Version
if ([Version] $osVersion -lt [version] $minimumOsVersion) {
  Write-Error "Microsoft Teams New Client requires a minimum of Windows 10 20H1 version $minimumOsVersion. You have $osVersion"
}

$bootstrapperChecksum32 = '92C41B13A22275690500353494834C9CCDEE7DD5CE6AC22193250C38208E77A6'
$msix64url = 'https://statics.teams.cdn.office.net/production-windows-x64/24091.214.2846.1452/MSTeams-x64.msix'
$msix64checksum = '0483DCA84E88B9BF6D5E609D821AE06C3B6126218F3483A10F9F5769F354887F'
$msix86url = 'https://statics.teams.cdn.office.net/production-windows-x86/24091.214.2846.1452/MSTeams-x86.msix'
$msix86checksum = '5D9C3E8AA031979C213B0F324EB5D243ACF976EDAF8F6B7296F984F3246F14ED'


$downloadPath = Join-Path $toolsDir "teamsbootstrapper.exe"

$pp = Get-PackageParameters

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  softwareName  = 'microsoft-teams-new-bootstrapper*'
  fileType      = 'exe'
  
  url           = "https://statics.teams.cdn.office.net/production-teamsprovision/lkg/teamsbootstrapper.exe"
  checksum      = $bootstrapperChecksum32
  checksumType  = 'sha256'
  FileFullPath  = $downloadPath
}

Get-ChocolateyWebFile @packageArgs

# Teams MSIX

$filename = "MSTeams.msix"
$installPath = Join-Path $toolsDir $filename

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  
  # webView2Canary
  url           = $msix86url
  checksum      = $msix86checksum
  checksumType  = 'sha256'
  url64bit      = $msix64url
  checksum64    = $msix64checksum
  checksumType64= 'sha256'
  fileFullPath  = $installPath
}

Get-ChocolateyWebFile @packageArgs

Write-Host "Installing $downloadPath with $installPath"
# Execute bootstrapper.exe, passing in path to msix file
& $downloadPath -p -o "$installPath"

if($pp['VDI']){
  $teamsVersion = Get-AppXPackage -Name "*msteams*" | Select-Object -ExpandProperty Version
  $meetingInstaller = "$($env:ProgramFiles)\WINDOWSAPPS\MSTEAMS_$($teamsVersion)_X64__8WEKYB3D8BBWE\MICROSOFTTEAMSMEETINGADDININSTALLER.MSI"
  $meetingVersion = (Get-AppLockerFileInformation -Path $meetingInstaller | Select-Object -ExpandProperty Publisher | Select-Object -ExpandProperty BinaryVersion).ToString()
  $packageArgsMeeting =@{
    packageName  = $env:ChocolateyPackageName +"_MeetingAddIn"
    fileType     = "msi"
    file         = $meetingInstaller
    SilentArgs   = "/qn /norestart ALLUSERS=1  TARGETDIR=`"$($env:ProgramFiles)\Microsoft\TeamsMeetingAdd-in\$($meetingVersion)\`" /l*v `"$($env:TEMP)\$($packageName).meetingAddin_$($meetingVersion).MsiInstall.log`""
  }

  Install-ChocolateyInstallPackage @packageArgsMeeting 
}
