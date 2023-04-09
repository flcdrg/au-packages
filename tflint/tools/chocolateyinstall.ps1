$ErrorActionPreference = 'Stop'; # stop on all errors
$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$packageArgs = @{
    packageName    = 'tflint'

    # 32-bit
    url            = 'https://github.com/terraform-linters/tflint/releases/download/v0.46.0/tflint_windows_386.zip'
    checksum       = 'fb055a145c7e7738b14995f40d66322fa294e61d34fb30a1f23734c31aa54c03'
    checksumType   = 'sha256'

    # 64-bit
    url64bit       = 'https://github.com/terraform-linters/tflint/releases/download/v0.46.0/tflint_windows_amd64.zip'
    checksum64     = '80deea1af9a9f260f959ca9aca45e74c219c0f484d745f9e0ae519e6425c2804'
    checksumType64 = $checksumType

    # misc
    unziplocation  = "$toolsDir"
}

Install-ChocolateyZipPackage @packageArgs
