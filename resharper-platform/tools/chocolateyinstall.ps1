$ErrorActionPreference = 'Stop'; # stop on all errors
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$filename = 'JetBrains.dotUltimate.2020.3.3.exe'
$checksum = 'd460fde4e1c22a7d3b02f8c308961f6e3cf96e7e98cd18de2ecfeb321c9fae81'

$url = 'https://download.jetbrains.com/resharper/dotUltimate.2020.3.3/JetBrains.dotUltimate.2020.3.3.exe'
$packagePath = $(Split-Path -parent $toolsDir)
$installPath = Join-Path $packagePath $filename

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  fileFullPath  = $installPath
  url           = $url
  checksum      = $checksum
  checksumType  = 'sha256'
}

Get-ChocolateyWebFile @packageArgs

# Exclude from shimming
$files = get-childitem $packagePath -include *.exe -recurse

foreach ($file in $files) {
  New-Item "$file.ignore" -type file -force | Out-Null
}
