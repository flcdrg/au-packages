$ErrorActionPreference = 'Stop'; # stop on all errors
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$filename = 'JetBrains.dotUltimate.2024.3.RC1.Checked.exe'
$checksum = '13876c7d4f821ce4febeab0870a76b82d8a29b05d0f5a3dd11be559d6c337c48'

$url = 'https://download.jetbrains.com/resharper/dotUltimate.2024.3.RC1/JetBrains.dotUltimate.2024.3.RC1.Checked.exe'
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
