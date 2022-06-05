$ErrorActionPreference = 'Stop'; # stop on all errors
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$filename = 'JetBrains.dotUltimate.2022.2.EAP3.Checked.exe'
$checksum = 'a678354dc4a3a15eb068deaacfe6fbc3e7c3cdd04f1de8454a7ff7f5720548d6'

$url = 'https://download.jetbrains.com/resharper/dotUltimate.2022.2.EAP3/JetBrains.dotUltimate.2022.2.EAP3.Checked.exe'
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
