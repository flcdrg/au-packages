$ErrorActionPreference = 'Stop'; # stop on all errors
$packageName = 'PDFXchangePro' 
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$version    = [version] $env:ChocolateyPackageVersion

if ( $version.Revision -gt 20210101 ) {
    $version = New-Object version $version.Major, $version.Minor, $version.Build, 0
    Write-Warning "'Package fix version notation' detected. Assuming original build version was .0"
}

$filename   = 'ProV10.x86.msi'
$filename64 = 'ProV10.x64.msi'
$url        = 'https://downloads.pdf-xchange.com/ProV10.x86.msi'
$url64      = 'https://downloads.pdf-xchange.com/ProV10.x64.msi'
$checksum   = '9F212F6A2CACC42DA98D56312E059567F8104AB6EABF3ED725E1451C9B6EC0AC'
$checksum64 = '3DCDD663479646A760437DC261F54F65F0385AAF36733036CFB8E496E2A8FE90'
$lastModified32 = New-Object -TypeName DateTimeOffset 2025, 5, 5, 23, 50, 59, 0 # Last modified time corresponding to this package version
$lastModified64 = New-Object -TypeName DateTimeOffset 2025, 5, 5, 23, 51, 19, 0 # Last modified time corresponding to this package version

$packageArgs = @{
  packageName   = $packageName
  unzipLocation = $toolsDir
  fileType      = 'MSI'
  url           = $url
  url64bit      = $url64
  silentArgs = '/quiet /norestart'
  validExitCodes= @(0, 3010, 1641)

  softwareName  = 'PDF-XChange Pro'

  checksum = $checksum
  checksumType  = 'sha256' 
  checksum64 = $checksum64
  checksumType64= 'sha256' 
}

$packageParameters = Get-PackageParameters

$customArguments = @{}

if ($packageParameters) {
    # http://help.tracker-software.com/EUM/default.aspx?pageid=PDFXEdit3:switches_for_msi_installers

    if ($packageParameters.ContainsKey("NoDesktopShortcuts")) {
        Write-Host "You want NoDesktopShortcuts"
        $customArguments.Add("DESKTOP_SHORTCUTS", "0")
    }

    if ($packageParameters.ContainsKey("NoUpdater")) {
        Write-Host "You want NoUpdater"
        $customArguments.Add("NOUPDATER", "1")
    }

    if ($packageParameters.ContainsKey("NoViewInBrowsers")) {
        Write-Host "You want NoViewInBrowsers"
        $customArguments.Add("VIEW_IN_BROWSERS", "0")
    }

    if ($packageParameters.ContainsKey("NoSetAsDefault")) {
        Write-Host "You want NoSetAsDefault"
        $customArguments.Add("SET_AS_DEFAULT", "0")
    }

    if ($packageParameters.ContainsKey("NoProgramsMenuShortcuts")) {
        Write-Host "You want NoProgramsMenuShortcuts"
        $customArguments.Add("PROGRAMSMENU_SHORTCUTS", "0")
    }

    if ($packageParameters.ContainsKey("KeyFile")) {
        if ($packageParameters["KeyFile"] -eq "") {
          Throw 'KeyFile needs a colon-separated argument; try something like this: --params "/KeyFile:C:\Users\foo\Temp\PDFXChangeEditor.xcvault".'
        } else {
          Write-Host "You want a KeyFile named $($packageParameters["KeyFile"])"
          $customArguments.Add("KEYFILE", $packageParameters["KeyFile"])
        }
    }

} else {
    Write-Debug "No Package Parameters Passed in"
}

if ($customArguments.Count) { 
    $packageArgs.silentArgs += " " + (($customArguments.GetEnumerator() | ForEach-Object { "$($_.Name)=$($_.Value)" } ) -join " ")
}

Install-ChocolateyPackage @packageArgs
