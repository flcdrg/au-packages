$ErrorActionPreference = 'Stop'; # stop on all errors
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$filename = 'JetBrains.dotUltimate.2026.3.0.2.exe'
$checksum = 'be3189e6e55938f6d221b873efe98afe3b9427e0b01d7621cad26c354224637b'

$url = 'https://download.jetbrains.com/resharper/dotUltimate.2026.3.0.2/JetBrains.dotUltimate.2026.3.0.2.zip'
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
