$ErrorActionPreference = 'Stop';
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$url        = 'https://download.microsoft.com/download/a89001cb-9c99-48d3-9f14-ded054b35fe4/SQLServer2022-KB5125472-x64.exe'
$urlFallback = 'https://catalog.s.download.windowsupdate.com/d/msdownload/update/software/updt/2026/11/sqlserver2022-kb5125472-x64_377f4f315e7557032060fd3430d23939fe12ee8f.exe'
$checksum   = '0c0fde7858b349b476d2b667f399e707a67235f1c4aedfd68564c3534192f686'
$softwareName = 'Hotfix 4325 for SQL Server 2022*(KB5125472)*'

[bool] $runningAU = (Test-Path Function:\au_GetLatest)

. $toolsDir\Get-PendingReboot.ps1

if (([Version] (Get-CimInstance Win32_OperatingSystem).Version -lt [version] "10.0.0.0") -and -not $runningAU) {
  Write-Error "SQL Server 2022 requires a minimum of Windows 10 or Windows Server 2016"
}

$pp = Get-PackageParameters

if ( (!$pp['IGNOREPENDINGREBOOT']) -and (Get-PendingReboot).RebootPending -and -not $runningAU) {
  Write-Error "A system reboot is pending. You must restart Windows first before installing SQL Server updates"
}

$useFallback = [bool] $pp['USEFALLBACK']

if ($useFallback) {
  if ([string]::IsNullOrWhiteSpace($urlFallback)) {
    Write-Error "USEFALLBACK was specified but this package has no fallback URL"
  }

  Write-Host "USEFALLBACK specified. Downloading from the Microsoft Update Catalog fallback URL."
  $url = $urlFallback
}

$filename = [IO.Path]::GetFileName($url)

# Download like Install-ChocolateyPackage (so we can restart from cached download)
$chocTempDir = $env:TEMP

$tempDir = Join-Path $chocTempDir "$($env:chocolateyPackageName)"
if ($env:chocolateyPackageVersion -ne $null) { $tempDir = Join-Path $tempDir "$($env:chocolateyPackageVersion)"; }
$tempDir = $tempDir -replace '\\chocolatey\\chocolatey\\', '\chocolatey\'
if (![System.IO.Directory]::Exists($tempDir)) { [System.IO.Directory]::CreateDirectory($tempDir) | Out-Null }
$downloadFilePath = Join-Path $tempDir $filename

$fullFilePath = Join-Path $toolsDir $filename

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  url           = $url
  FileFullPath  = $downloadFilePath
  checksum      = $checksum
  checksumType  = 'sha256'
}

$filePath = $null

try {
  $filePath = Get-ChocolateyWebFile @packageArgs
} catch {
  if ($useFallback -or [string]::IsNullOrWhiteSpace($urlFallback)) {
    throw
  }

  Write-Warning "Primary download URL failed. Retrying with Microsoft Update Catalog fallback URL."
  $packageArgs.url = $urlFallback
  $packageArgs.FileFullPath = Join-Path $tempDir ([IO.Path]::GetFileName($urlFallback))
  $filePath = Get-ChocolateyWebFile @packageArgs
}

if (Test-Path Function:\au_GetLatest) {
  return
}

# Copy into tools to keep for uninstall
Copy-Item $filePath -Destination $fullFilePath

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  file  = $fullFilePath
  softwareName  = $softwareName
  silentArgs    = "/q /IAcceptSQLServerLicenseTerms /Action=Patch /AllInstances"
  validExitCodes= @(0, 3010, 1641)
}

Install-ChocolateyInstallPackage @packageArgs

$files = get-childitem $toolsDir -include *.exe -recurse

foreach ($file in $files) {
  # generate an ignore file
  New-Item "$file.ignore" -type file -force | Out-Null
}
