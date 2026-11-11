$ErrorActionPreference = 'Stop'
$toolsDir = "$(Split-Path -Parent $MyInvocation.MyCommand.Definition)"
$locationFile = Join-Path $toolsDir 'install-location.txt'

if (-not (Test-Path -LiteralPath $locationFile)) {
    return
}

$installDir = (Get-Content -LiteralPath $locationFile -Raw).Trim()
$userInstallDir = Join-Path $env:USERPROFILE '.dotnetup'
if ($installDir -ne $userInstallDir) {
    throw "dotnetup was installed for another account at '$installDir'. Uninstall using the account that installed the package."
}

$executable = Join-Path $installDir 'dotnetup.exe'
if (Test-Path -LiteralPath $executable) {
    Remove-Item -LiteralPath $executable -Force
}
Uninstall-ChocolateyPath -Path $installDir -PathType User

Write-Host 'Managed .NET SDKs, runtimes, dotnetup data, and manually configured .NET environment settings have been preserved.'
