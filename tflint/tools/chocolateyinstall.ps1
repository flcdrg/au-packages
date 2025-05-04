$ErrorActionPreference = 'Stop'; # stop on all errors
$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$packageArgs = @{
    packageName    = 'tflint'

    # 32-bit
    url            = 'https://github.com/terraform-linters/tflint/releases/download/v0.57.0/tflint_windows_386.zip'
    checksum       = '634b363a6e9996e05183e5615ae1bb1ed3c41af42ad778554f798f8fc8bb309a'
    checksumType   = 'sha256'

    # 64-bit
    url64bit       = 'https://github.com/terraform-linters/tflint/releases/download/v0.57.0/tflint_windows_amd64.zip'
    checksum64     = 'ed0ef8236e632d78e951aa5335d19cbd591f746267e8b60655be4b29f68e4d2c'
    checksumType64 = $checksumType

    # misc
    unziplocation  = "$toolsDir"
}

Install-ChocolateyZipPackage @packageArgs
