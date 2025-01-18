$ErrorActionPreference = 'Stop'; # stop on all errors
$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$packageArgs = @{
    packageName    = 'tflint'

    # 32-bit
    url            = 'https://github.com/terraform-linters/tflint/releases/download/v0.55.0/tflint_windows_386.zip'
    checksum       = '254b49ab23e5641f92f080d4d50c6e6bdb392028199ea6728a6e663367e1dffc'
    checksumType   = 'sha256'

    # 64-bit
    url64bit       = 'https://github.com/terraform-linters/tflint/releases/download/v0.55.0/tflint_windows_amd64.zip'
    checksum64     = 'eb60c8b72896b86e947ea69960472905a6a4063f4904d9e479b91eabe61c3b11'
    checksumType64 = $checksumType

    # misc
    unziplocation  = "$toolsDir"
}

Install-ChocolateyZipPackage @packageArgs
