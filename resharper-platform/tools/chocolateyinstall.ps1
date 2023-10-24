$ErrorActionPreference = 'Stop'; # stop on all errors
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$filename = 'JetBrains.dotUltimate.2023.3.EAP4.Checked.exe'
$checksum = '57b34f085dbed64ddecdc41b519478e7cf33c546ddaddd0e4c087c9f5fdfcc5b'

$url = 'https://download.jetbrains.com/resharper/dotUltimate.2023.3.EAP4/JetBrains.dotUltimate.2023.3.EAP4.Checked.exe'
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
