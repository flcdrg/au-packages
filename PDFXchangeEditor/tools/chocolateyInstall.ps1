﻿$ErrorActionPreference = 'Stop'; # stop on all errors
$packageName = 'PDFXchangeEditor' 
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$version    = $env:ChocolateyPackageVersion
$filename   = 'EditorV7.x86.msi'
$filename64 = 'EditorV7.x64.msi'
$primaryDownloadUrl = "http://downloads.pdf-xchange.com/$filename"
$primaryDownloadUrl64 = "http://downloads.pdf-xchange.com/$filename64"
$url        = "http://www.docu-track.co.uk/builds/$version/$filename"
$url64      = "http://www.docu-track.co.uk/builds/$version/$filename64"
$checksum   = '79AC24E9C12996BA297AC140ACC5D383F7E7E6B1ACBC02EC00D8821F9EB835CE'
$checksum64 = 'B80E11F6A36181943B0AEAE09C2A1C413AC61943F185D81688719905E2B28276'
$lastModified32 = New-Object -TypeName DateTimeOffset 2018, 4, 24, 22, 13, 36, 0 # Last modified time corresponding to this package version
$lastModified64 = New-Object -TypeName DateTimeOffset 2018, 4, 24, 22, 15, 53, 0 # Last modified time corresponding to this package version

# Tracker Software have fixed download URLs, but if the binary changes we can fall back to their alternate (but slower) download site
# so the package doesn't break.
function CheckDownload($url, $primaryDownloadUrl, [DateTimeOffset] $packageVersionLastModified)
{
    $headers = Get-WebHeaders -url $primaryDownloadUrl
    $lastModifiedHeader = $headers.'Last-Modified'

    $lastModified = [DateTimeOffset]::Parse($lastModifiedHeader, [Globalization.CultureInfo]::InvariantCulture)

    Write-Verbose "Package LastModified: $packageVersionLastModified"
    Write-Verbose "HTTP Last Modified  : $lastModified"

    if ($lastModified -ne $packageVersionLastModified) {
        Write-Warning "The download available at $primaryDownloadUrl has changed from what this package was expecting. Falling back to FTP for version-specific URL"
        $url
    } else {
        Write-Verbose "Primary URL matches package expectation"
        $primaryDownloadUrl
    }
}

$url = CheckDownload $url $primaryDownloadUrl $lastModified32
$url64 = CheckDownload $url64 $primaryDownloadUrl64 $lastModified64

$packageArgs = @{
  packageName   = $packageName
  unzipLocation = $toolsDir
  fileType      = 'MSI'
  url           = $url
  url64bit      = $url64
  silentArgs = '/quiet /norestart'
  validExitCodes= @(0, 3010, 1641)

  softwareName  = 'PDF-XChange Editor'

  checksum = $checksum
  checksumType  = 'sha256' 
  checksum64 = $checksum64
  checksumType64= 'sha256' 
}

$arguments = @{}

$packageParameters = $env:chocolateyPackageParameters

if ($packageParameters) {
    $match_pattern = "\/(?<option>([a-zA-Z]+)):(?<value>([`"'])?([a-zA-Z0-9- _\\:\.]+)([`"'])?)|\/(?<option>([a-zA-Z]+))"
    $option_name = 'option'
    $value_name = 'value'

    if ($packageParameters -match $match_pattern ){
        $results = $packageParameters | Select-String $match_pattern -AllMatches
        $results.matches | ForEach-Object {
        $arguments.Add(
            $_.Groups[$option_name].Value.Trim(),
            $_.Groups[$value_name].Value.Trim())
    }
    }
    else
    {
        Throw "Package Parameters were found but were invalid (REGEX Failure)"
    }

    # http://help.tracker-software.com/EUM/default.aspx?pageid=PDFXEdit3:switches_for_msi_installers
    $customArguments = @{}

    if ($arguments.ContainsKey("NoDesktopShortcuts")) {
        Write-Host "You want NoDesktopShortcuts"
        $customArguments.Add("DESKTOP_SHORTCUTS", "0")
    }

    if ($arguments.ContainsKey("NoUpdater")) {
        Write-Host "You want NoUpdater"
        $customArguments.Add("NOUPDATER", "1")
    }

    if ($arguments.ContainsKey("NoViewInBrowsers")) {
        Write-Host "You want NoViewInBrowsers"
        $customArguments.Add("VIEW_IN_BROWSERS", "0")
    }

    if ($arguments.ContainsKey("NoSetAsDefault")) {
        Write-Host "You want NoSetAsDefault"
        $customArguments.Add("SET_AS_DEFAULT", "0")
    }

    if ($arguments.ContainsKey("NoProgramsMenuShortcuts")) {
        Write-Host "You want NoProgramsMenuShortcuts"
        $customArguments.Add("PROGRAMSMENU_SHORTCUTS", "0")
    }

    if ($arguments.ContainsKey("KeyFile")) {
        if ($arguments["KeyFile"] -eq "") {
          Throw 'KeyFile needs a colon-separated argument; try something like this: --params "/KeyFile:C:\Users\foo\Temp\PDFXChangeEditor.xcvault".'
        } else {
          Write-Host "You want a KeyFile named $($arguments["KeyFile"])"
          $customArguments.Add("KEYFILE", $arguments["KeyFile"])
        }
    }

} else {
    Write-Debug "No Package Parameters Passed in"
}

if ($customArguments.Count) { 
    $packageArgs.silentArgs += " " + (($customArguments.GetEnumerator() | ForEach-Object { "$($_.Name)=$($_.Value)" } ) -join " ")
}

Install-ChocolateyPackage @packageArgs
