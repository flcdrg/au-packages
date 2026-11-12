$ErrorActionPreference = 'Stop'; # stop on all errors
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$filename = 'JetBrains.dotUltimate.2026.3.exe'
$checksum = '0f0322b2e3a8cdca8a137a4c5d3eba093fa348bbfe36fa2d15cb01a088b587f4'

$url = 'https://download.jetbrains.com/resharper/dotUltimate.2026.3/JetBrains.dotUltimate.2026.3.zip'
$packagePath = $(Split-Path -parent $toolsDir)
$installPath = Join-Path $packagePath $filename

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  unzipLocation = $packagePath
  url           = $url
  checksum      = $checksum
  checksumType  = 'sha256'
}

Install-ChocolateyZipPackage @packageArgs

if (-not (Test-Path -LiteralPath $installPath -PathType Leaf)) {
  throw "The offline archive did not contain the expected installer: $filename"
}

# Exclude from shimming
$files = get-childitem $packagePath -include *.exe -recurse

foreach ($file in $files) {
  New-Item "$file.ignore" -type file -force | Out-Null
}
