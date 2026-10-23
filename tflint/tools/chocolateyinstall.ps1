$ErrorActionPreference = 'Stop'; # stop on all errors
$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$packageArgs = @{
    packageName    = 'tflint'

    # 32-bit
    url            = 'https://github.com/terraform-linters/tflint/releases/download/v0.65.0/tflint_windows_386.zip'
    checksum       = '7fa68d755de67547016a6a04ee9fef8d2aaea66ec434a0140a59a1a419e5269e'
    checksumType   = 'sha256'

    # 64-bit
    url64bit       = 'https://github.com/terraform-linters/tflint/releases/download/v0.65.0/tflint_windows_amd64.zip'
    checksum64     = '292e760adf0e9c7e0f10ddeb0f6add67fd6d2c68b5449fdf766ff6ffddce465c'
    checksumType64 = $checksumType

    # misc
    unziplocation  = "$toolsDir"
}

Install-ChocolateyZipPackage @packageArgs
