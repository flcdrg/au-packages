$ErrorActionPreference = 'Stop'; # stop on all errors
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$filename = 'JetBrains.dotUltimate.2026.3.0.1.exe'
$checksum = '0e60e1803c9e1e418ba8b7946b97ae8d80a363d07a54891befdbdf3204201c15'

$url = 'https://download.jetbrains.com/resharper/dotUltimate.2026.3.0.1/JetBrains.dotUltimate.2026.3.0.1.zip'
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
