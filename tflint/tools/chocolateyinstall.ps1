$ErrorActionPreference = 'Stop'; # stop on all errors
$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$packageArgs = @{
    packageName    = 'tflint'

    # 32-bit
    url            = 'https://github.com/terraform-linters/tflint/releases/download/v0.54.0/tflint_windows_386.zip'
    checksum       = '7047f215da378067f282e9e8a0110a23c0c18cfad56c646b08eb6d9821fada9c'
    checksumType   = 'sha256'

    # 64-bit
    url64bit       = 'https://github.com/terraform-linters/tflint/releases/download/v0.54.0/tflint_windows_amd64.zip'
    checksum64     = 'e11133209b031ccc055936bf8a1472b3b71993f9658a27e6b5863d793c6873a3'
    checksumType64 = $checksumType

    # misc
    unziplocation  = "$toolsDir"
}

Install-ChocolateyZipPackage @packageArgs
