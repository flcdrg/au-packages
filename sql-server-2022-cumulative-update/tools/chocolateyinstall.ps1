$ErrorActionPreference = 'Stop';
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$url        = 'https://download.microsoft.com/download/a89001cb-9c99-48d3-9f14-ded054b35fe4/SQLServer2022-KB5104824-x64.exe'
$urlFallback = 'https://catalog.s.download.windowsupdate.com/d/msdownload/update/software/updt/2026/09/sqlserver2022-kb5104824-x64_0eba1dc82bfe270e990304be309760e1fe831552.exe'
$checksum   = '675e3cedd6c7a3d0ffbe713e46e54a86a92af7b96ca4a6beb987ae99c79b96f5'
$softwareName = 'Hotfix 4295 for SQL Server 2022*(KB5104824)*'

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
