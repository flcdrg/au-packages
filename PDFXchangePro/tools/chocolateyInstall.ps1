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
$checksum   = '80A39EDAC42AC1F90B4A4C6C3BFB8E8329153FA365699816D50696CBD5E7940B'
$checksum64 = '3142D168F5557EBDAACCCEC0431310E91358C67B6D04AA7A2D230E13993274AC'
$lastModified32 = New-Object -TypeName DateTimeOffset 2025, 9, 2, 22, 0, 16, 0 # Last modified time corresponding to this package version
$lastModified64 = New-Object -TypeName DateTimeOffset 2025, 9, 2, 22, 1, 18, 0 # Last modified time corresponding to this package version

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
