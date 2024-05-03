$ErrorActionPreference = 'Stop'; # stop on all errors
$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$packageArgs = @{
    packageName    = 'tflint'

    # 32-bit
    url            = 'https://github.com/terraform-linters/tflint/releases/download/v0.51.0/tflint_windows_386.zip'
    checksum       = 'ee897908e0b19ffdb66f3a6be528ed88fd6db9d2a1eca4007d88b83d62784b8a'
    checksumType   = 'sha256'

    # 64-bit
    url64bit       = 'https://github.com/terraform-linters/tflint/releases/download/v0.51.0/tflint_windows_amd64.zip'
    checksum64     = '760afe663a13f3c1216ec2bc12fdda0dfd3e38d67c131accc94f79db137fdd00'
    checksumType64 = $checksumType

    # misc
    unziplocation  = "$toolsDir"
}

Install-ChocolateyZipPackage @packageArgs
