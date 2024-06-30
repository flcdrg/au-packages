$ErrorActionPreference = 'Stop'; # stop on all errors
$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$packageArgs = @{
    packageName    = 'tflint'

    # 32-bit
    url            = 'https://github.com/terraform-linters/tflint/releases/download/v0.51.2/tflint_windows_386.zip'
    checksum       = 'e36830c559361c6381c3805d5cc431039d173459f2b6428ab90d410e3da35f38'
    checksumType   = 'sha256'

    # 64-bit
    url64bit       = 'https://github.com/terraform-linters/tflint/releases/download/v0.51.2/tflint_windows_amd64.zip'
    checksum64     = '041e6b961d47c78b5ba85ac67e888e74c0f811f87fca78ce93d4cdf8078b0f35'
    checksumType64 = $checksumType

    # misc
    unziplocation  = "$toolsDir"
}

Install-ChocolateyZipPackage @packageArgs
