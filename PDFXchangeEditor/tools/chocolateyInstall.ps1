$ErrorActionPreference = 'Stop'; # stop on all errors
$packageName = 'PDFXchangeEditor' 
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$version    = $env:ChocolateyPackageVersion
$filename   = 'EditorV9.x86.msi'
$filename64 = 'EditorV9.x64.msi'
$primaryDownloadUrl = "https://downloads.pdf-xchange.com/$filename"
$primaryDownloadUrl64 = "https://downloads.pdf-xchange.com/$filename64"
$url        = "http://www.docu-track.co.uk/builds/$version/$filename"
$url64      = "http://www.docu-track.co.uk/builds/$version/$filename64"
$checksum   = 'A706028F4288D5AAE5EC1D56E4F321B86849BE99B0431351A3530A957DB76C0D'
$checksum64 = 'A682AFBD026837B17D97D8615B4C160B5AD5FD5CD5A460A3E37EBAF3B87B5BCF'
$lastModified32 = New-Object -TypeName DateTimeOffset 2021, 1, 14, 20, 43, 12, 0 # Last modified time corresponding to this package version
$lastModified64 = New-Object -TypeName DateTimeOffset 2021, 1, 14, 20, 44, 36, 0 # Last modified time corresponding to this package version

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
