$ErrorActionPreference = 'Stop'; # stop on all errors
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$filename = 'JetBrains.dotUltimate.2026.2.EAP9.Checked.exe'
$checksum = 'a9ad6f519354835fbb30cb05ffb1d9357f9bcf5efad4ea7f7ae7da0ae62f5bd6'

$url = 'https://download.jetbrains.com/resharper/dotUltimate.2026.2.EAP9/JetBrains.dotUltimate.2026.2.EAP9.Checked.exe'
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
