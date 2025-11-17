$ErrorActionPreference = 'Stop'; # stop on all errors
$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$packageArgs = @{
    packageName    = 'tflint'

    # 32-bit
    url            = 'https://github.com/terraform-linters/tflint/releases/download/v0.60.0/tflint_windows_386.zip'
    checksum       = '561a7c633009f4dcba82769742d7b1d14b64a5795a0868db5d3311ef19514998'
    checksumType   = 'sha256'

    # 64-bit
    url64bit       = 'https://github.com/terraform-linters/tflint/releases/download/v0.60.0/tflint_windows_amd64.zip'
    checksum64     = 'a6e08412ec6bf9041325d75a0b88846f8e3b8fb24e5dda105574fa7565235f4c'
    checksumType64 = $checksumType

    # misc
    unziplocation  = "$toolsDir"
}

Install-ChocolateyZipPackage @packageArgs
