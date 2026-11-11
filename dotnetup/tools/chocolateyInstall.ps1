$ErrorActionPreference = 'Stop'
$toolsDir = "$(Split-Path -Parent $MyInvocation.MyCommand.Definition)"
$installDir = Join-Path $env:USERPROFILE '.dotnetup'
$locationFile = Join-Path $toolsDir 'install-location.txt'
if (Test-Path -LiteralPath $locationFile) {
    $previousInstallDir = (Get-Content -LiteralPath $locationFile -Raw).Trim()
    if ($previousInstallDir -ne $installDir) {
        throw "dotnetup was installed for another account at '$previousInstallDir'. Upgrade using the account that installed the package."
    }
}

$urlX64 = 'https://ci.dot.net/public/dotnetup/0.3.0-preview.1.26554.3/dotnetup-win-x64.exe'
$checksumX64 = '85D52B5F0F13B1CB63FB0E7A54A0402268553496153CDC8A9CEBF4E9F2EEF6F7414C353902DE44AA51BF833BF4B4FFCC048E556DB049F3742CC9EA70ECA013B8'
$urlArm64 = 'https://ci.dot.net/public/dotnetup/0.3.0-preview.1.26554.3/dotnetup-win-arm64.exe'
$checksumArm64 = '85E2D9797C3A463FBA2E0B0E5E06D5DE0FBDC7C13BF57CECA41906710E564C7E8BDC86926A9787D3722694C5A5F7970275078FCB716697B5F246C9869AB2F6A4'

$nativeArchitecture = if ($env:PROCESSOR_ARCHITEW6432) {
    $env:PROCESSOR_ARCHITEW6432
} else {
    $env:PROCESSOR_ARCHITECTURE
}

switch ($nativeArchitecture.ToUpperInvariant()) {
    'AMD64' {
        $url = $urlX64
        $checksum = $checksumX64
    }
    'ARM64' {
        $url = $urlArm64
        $checksum = $checksumArm64
    }
    default {
        throw "$env:ChocolateyPackageName supports Windows x64 and Arm64. Detected '$nativeArchitecture'."
    }
}

$packageArgs = @{
    packageName   = $env:ChocolateyPackageName
    fileFullPath  = Join-Path $installDir 'dotnetup.exe'
    url           = $url
    checksum      = $checksum
    checksumType  = 'sha512'
}

New-Item -Path $installDir -ItemType Directory -Force | Out-Null
Get-ChocolateyWebFile @packageArgs
Set-Content -LiteralPath $locationFile -Value $installDir -Encoding UTF8
Install-ChocolateyPath -Path $installDir -PathType User

Write-Host "dotnetup is installed for '$env:USERNAME' in '$installDir'. Open a new terminal before running dotnetup."
