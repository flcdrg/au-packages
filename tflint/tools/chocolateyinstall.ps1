$ErrorActionPreference = 'Stop'; # stop on all errors
$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$packageArgs = @{
    packageName    = 'tflint'

    # 32-bit
    url            = 'https://github.com/terraform-linters/tflint/releases/download/v0.58.1/tflint_windows_386.zip'
    checksum       = '3f46e5dabb22784c930155b014eeea62f83e250a0ab0994a50e221f67c2929d6'
    checksumType   = 'sha256'

    # 64-bit
    url64bit       = 'https://github.com/terraform-linters/tflint/releases/download/v0.58.1/tflint_windows_amd64.zip'
    checksum64     = '4e5a9d4e1fda7a415516ed045da6fc56a466d1dd77840e3b4e68093a62f3d68d'
    checksumType64 = $checksumType

    # misc
    unziplocation  = "$toolsDir"
}

Install-ChocolateyZipPackage @packageArgs
