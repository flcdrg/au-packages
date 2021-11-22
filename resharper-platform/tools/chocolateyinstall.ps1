$ErrorActionPreference = 'Stop'; # stop on all errors
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$filename = 'JetBrains.dotUltimate.2021.3.EAP9.Checked.exe'
$checksum = '3e6ac08537e71f2ca138d94a9853faf21fe5509cb7f16857822ad4aa5cb27327'

$url = 'https://download.jetbrains.com/resharper/dotUltimate.2021.3.EAP9/JetBrains.dotUltimate.2021.3.EAP9.Checked.exe'
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
