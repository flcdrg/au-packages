$ErrorActionPreference = 'Stop'; # stop on all errors
$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$packageArgs = @{
    packageName    = 'tflint'

    # 32-bit
    url            = 'https://github.com/terraform-linters/tflint/releases/download/v0.63.0/tflint_windows_386.zip'
    checksum       = '45face39a7f67b46e00716ba058843138d4578ad083d7395ffe0c609196afa04'
    checksumType   = 'sha256'

    # 64-bit
    url64bit       = 'https://github.com/terraform-linters/tflint/releases/download/v0.63.0/tflint_windows_amd64.zip'
    checksum64     = 'de41fa9f690fa05fbd24e2e90f87e3690a31ac72068d7bc249a003e35501cfa7'
    checksumType64 = $checksumType

    # misc
    unziplocation  = "$toolsDir"
}

Install-ChocolateyZipPackage @packageArgs
