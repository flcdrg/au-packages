$ErrorActionPreference = 'Stop';

$packageName= 'iguana.install'
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url64      = 'http://dl.interfaceware.com/iguana/windows/6_1_5/iguana_noinstaller_6_1_5_windows_x64.zip'
$checksum64 = '20165b31a63c68b61d66445d46852f37715cfe33abd3bef34b02bded98447120'

$pp = Get-PackageParameters

if ($env:chocolateyForceX86 -and (Get-ProcessorBits 64)) {
    $programfiles = ${env:ProgramFiles(x86)}
} else {
    $programfiles = $env:ProgramFiles
}

# Default the values
$installationPath = "$programfiles\iNTERFACEWARE"
$log = "$installationPath\Iguana\Logs"
$port = "6543"
$excludeChameleon = $false

# Now parse the packageParameters using good old regular expression
if ($pp) {

    if ($pp.ContainsKey("Port")) {
        Write-Host "Port Argument Found"
        $port = $pp["Port"]
    }

    if ($pp.ContainsKey("ExcludeChameleon")) {
        Write-Host "Chameleon will not be installed"
        $excludeChameleon = $true
    }

    if ($pp.ContainsKey("InstallationPath")) {
        Write-Host "You want to use a custom Installation Path"
        $installationPath = $pp["InstallationPath"]
    }

    if ($pp.ContainsKey("Log")) {
        Write-Host "You want to use a custom Log Path"
        $log = $pp["Log"]
    }

} else {
    Write-Debug "No Package Parameters Passed in"
}

if (-not [System.IO.Path]::IsPathRooted($installationPath)) {
    Write-Error "Installation path '$installationPath' must be absolute, not relative"
}
<# 
 /DIRECTORY="path" - Install in this directory (default is C:\Program Files\iNTERFACEWARE)
 /CHAMELEON=1 - Install Chameleon
 /PORT="port" - Use this port for Iguana's web server (default is 6543)
 /LOG="path"  - Use this directory for Iguana's log files (default is <installation-directory>\Iguana\logs)
 #>

$silentArgs = "/S /PORT=`"" + $port + "`" /DIRECTORY=`"" + $installationPath + "`" /LOG=`"" + $log + "`""

if ($excludeChameleon) { 
    $silentArgs += " /CHAMELEON=0" 
}

Write-Debug "This would be the Chocolatey Silent Arguments: $silentArgs"

[bool] $runningAU = (Test-Path Function:\au_GetLatest)

# predefine firewall rule to avoid Windows Firewall dialog during install
if (-not(Get-NetFirewallRule | Where-Object { $_.DisplayName -eq "Iguana" })) {
    if (-not $runningAU) {
        New-NetFirewallRule -Name "Iguana" -DisplayName "Iguana" -Profile Private -Direction Inbound -Action Allow -Program "$installationPath\Iguana\iguana.exe"
    }
}

$packageArgs = @{
    packageName   = $packageName
    UnzipLocation = $toolsDir
    url64bit      = $url64
    checksum64    = $checksum64
    checksumType64= 'sha256'
  
    silentArgs   = $silentArgs
  
    validExitCodes= @(0) 
}

Install-ChocolateyZipPackage @packageArgs

$filename = Get-ChildItem -Path $toolsDir -Recurse -Filter Iguana.exe | Select-Object -First 1 -ExpandProperty FullName

if (-not $filename) {
    Write-Error "Could not find iguana.exe under $toolsDir"
}

$packageArgs = @{
  packageName   = $packageName
  unzipLocation = $toolsDir
  fileType      = 'EXE'
  file64        = $filename

  silentArgs   = $silentArgs

  validExitCodes= @(0) 
}

Install-ChocolateyInstallPackage @packageArgs
