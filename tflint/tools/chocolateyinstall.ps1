$ErrorActionPreference = 'Stop'; # stop on all errors
$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$packageArgs = @{
    packageName    = 'tflint'

    # 32-bit
    url            = 'https://github.com/terraform-linters/tflint/releases/download/v0.56.0/tflint_windows_386.zip'
    checksum       = 'f46e06f21d94c94444b266ba7e66b40af418caadfe1d7d633aa06f91a4150c1c'
    checksumType   = 'sha256'

    # 64-bit
    url64bit       = 'https://github.com/terraform-linters/tflint/releases/download/v0.56.0/tflint_windows_amd64.zip'
    checksum64     = '8b1aeea099fb6bfae5cfc3437dc055909287ebef5212bbfcc6c3e211a515fef0'
    checksumType64 = $checksumType

    # misc
    unziplocation  = "$toolsDir"
}

Install-ChocolateyZipPackage @packageArgs
