$ErrorActionPreference = 'Stop';
$toolsDir               = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$packageArgs = @{
    PackageName    = $env:ChocolateyPackageName
    Destination    = $toolsDir
    FileFullPath   = Join-Path $toolsDir ''
    FileFullPath64 = Join-Path $toolsDir ''
}

Get-ChocolateyUnzip @packageArgs
