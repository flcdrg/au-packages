$ErrorActionPreference = 'Stop';
$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$minimumOsVersion = "10.0.19041" # 20H1
$osVersion = (Get-CimInstance Win32_OperatingSystem).Version
if ([Version] $osVersion -lt [version] $minimumOsVersion) {
  Write-Error "Microsoft Teams New Client requires a minimum of Windows 10 20H1 version $minimumOsVersion. You have $osVersion"
}

$checksum32 = '42DAC6D247B4138AD9ED858892FB608C3A8A2FD5F49E55D61E0C3D700AA3A369'
$downloadPath = Join-Path $toolsDir "teamsbootstrapper.exe"

$pp = Get-PackageParameters

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  softwareName  = 'microsoft-teams-new-bootstrapper*'
  fileType      = 'exe'
  
  url           = "https://statics.teams.cdn.office.net/production-teamsprovision/lkg/teamsbootstrapper.exe"
  checksum      = $checksum32
  checksumType  = 'sha256'
  FileFullPath  = $downloadPath
}

Get-ChocolateyWebFile @packageArgs

& $downloadPath -p

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
