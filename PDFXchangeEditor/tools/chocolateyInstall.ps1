$ErrorActionPreference = 'Stop'; # stop on all errors
$packageName = 'PDFXchangeEditor' 
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$url        = 'https://downloads.pdf-xchange.com/11.1.1.0/EditorV11.x86.msi'
$url64      = 'https://downloads.pdf-xchange.com/11.1.1.0/EditorV11.x64.msi'
$checksum   = '2662e02032049887bda1a7300b9d778653983ef3a7f2c4914afaf8c2526b25fe'
$checksum64 = 'de3cf6ed0532991a571bc8c9dd2415e6fe52930e763afaf67dd55a796616decf'

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

    if ($packageParameters.ContainsKey("KeyData")) {
        if ($packageParameters["KeyData"] -eq "") {
          Throw 'KeyData needs a colon-separated argument; try something like this: --params ''/KeyData:PXP10-...l4Q=''.'
        } else {
          Write-Host "You want to use KeyData"
          $customArguments.Add("KEYDATA", $packageParameters["KeyData"])
        }
    }

} else {
    Write-Debug "No Package Parameters Passed in"
}

if ($customArguments.Count) { 
    $packageArgs.silentArgs += " " + (($customArguments.GetEnumerator() | ForEach-Object { "$($_.Name)=$($_.Value)" } ) -join " ")
}

Install-ChocolateyPackage @packageArgs
