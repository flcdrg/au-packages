$ErrorActionPreference = 'Stop';
$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$minimumOsVersion = "10.0.19041" # 20H1
$osVersion = (Get-CimInstance Win32_OperatingSystem).Version
if ([Version] $osVersion -lt [version] $minimumOsVersion) {
  Write-Error "Microsoft Teams New Client requires a minimum of Windows 10 20H1 version $minimumOsVersion. You have $osVersion"
}

$bootstrapperChecksum32 = '42DAC6D247B4138AD9ED858892FB608C3A8A2FD5F49E55D61E0C3D700AA3A369'
$msix64url = 'https://statics.teams.microsoft.com/production-windows-x64/24004.1307.2669.7070/MSTeams-x64.msix'
$msix64checksum = 'ABA78B34B5E0BFD29AED18A86A926427B17127D80457C829C1512534510E7CD2'
$msix86url = 'https://statics.teams.microsoft.com/production-windows-x86/24004.1307.2669.7070/MSTeams-x86.msix'
$msix86checksum = '623647219971370D3E08D703E0A3CE197B978C221E77B108089A2A1F9E28F800'


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
