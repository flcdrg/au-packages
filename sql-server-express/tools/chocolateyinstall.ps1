$ErrorActionPreference = 'Stop';

if ([Version] (Get-CimInstance Win32_OperatingSystem).Version -lt [version] "10.0.0.0") {
    Write-Error "SQL Server 2022 requires a minimum of Windows 10 or Windows Server 2016"
}

$packageName= $env:ChocolateyPackageName
$url64      = 'https://download.microsoft.com/download/3/8/d/38de7036-2433-4207-8eae-06e247e17b25/SQLEXPR_x64_ENU.exe'
$checksum   = '2E61C8BBDE6021F9026C54AD9DB4BBB1227E68761D4C00A6A50A2C70FE7AFE05'
$packageParameters = Get-PackageParameters
$silentArgs = "/IACCEPTSQLSERVERLICENSETERMS /Q /ACTION=install /INSTANCEID=SQLEXPRESS /INSTANCENAME=SQLEXPRESS /UPDATEENABLED=FALSE"
if ($packageParameters['ConfigurationFile']) {
    $configPath = $packageParameters['ConfigurationFile']
    if (-not (Test-Path -Path $configPath)) {
        throw "ConfigurationFile not found: $configPath"
    }
    $silentArgs = "/IACCEPTSQLSERVERLICENSETERMS /Q /ConfigurationFile=`"$configPath`""
}

$tempDir = Join-Path (Get-Item $env:TEMP).FullName "$packageName"
if ($null -ne $env:packageVersion) {$tempDir = Join-Path $tempDir "$env:packageVersion"; }

if (![System.IO.Directory]::Exists($tempDir)) { [System.IO.Directory]::CreateDirectory($tempDir) | Out-Null }
$fileFullPath = "$tempDir\SQLEXPR.exe"

Get-ChocolateyWebFile -PackageName $packageName -FileFullPath $fileFullPath -Url64bit $url64 -Checksum $checksum -ChecksumType 'sha256'

Write-Host "Extracting..."
$extractPath = "$tempDir\SQLEXPR"
Start-Process "$fileFullPath" "/Q /x:`"$extractPath`"" -Wait

Write-Host "Installing..."
$setupPath = "$extractPath\setup.exe"
Install-ChocolateyInstallPackage "$packageName" "EXE" "$silentArgs" "$setupPath" -validExitCodes @(0, 3010, 1116)

Write-Host "Removing extracted files..."
Remove-Item -Recurse "$extractPath"
