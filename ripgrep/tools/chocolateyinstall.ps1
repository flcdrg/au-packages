$ErrorActionPreference = 'Stop';
$toolsDir               = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$packageArgs = @{
    PackageName    = $env:ChocolateyPackageName
    Destination    = $toolsDir
    FileFullPath   = Join-Path $toolsDir 'ripgrep-15.2.0-i686-pc-windows-msvc.zip'
    FileFullPath64 = Join-Path $toolsDir 'ripgrep-15.2.0-x86_64-pc-windows-msvc.zip'
}

Get-ChocolateyUnzip @packageArgs
