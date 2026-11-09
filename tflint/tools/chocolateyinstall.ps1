$ErrorActionPreference = 'Stop'; # stop on all errors
$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$packageArgs = @{
    packageName    = 'tflint'

    # 32-bit
    url            = 'https://github.com/terraform-linters/tflint/releases/download/v0.66.0/tflint_windows_386.zip'
    checksum       = '0ffffe98b8ff1b093822f724617abc30be247f205ecb38f94e6799f829518727'
    checksumType   = 'sha256'

    # 64-bit
    url64bit       = 'https://github.com/terraform-linters/tflint/releases/download/v0.66.0/tflint_windows_amd64.zip'
    checksum64     = 'e3acd1d89c735ce6e09108c9277f26076ebeb385c1f77a73c1cbf1826ed626a7'
    checksumType64 = $checksumType

    # misc
    unziplocation  = "$toolsDir"
}

Install-ChocolateyZipPackage @packageArgs
