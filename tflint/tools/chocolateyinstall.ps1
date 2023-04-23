$ErrorActionPreference = 'Stop'; # stop on all errors
$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$packageArgs = @{
    packageName    = 'tflint'

    # 32-bit
    url            = 'https://github.com/terraform-linters/tflint/releases/download/v0.46.1/tflint_windows_386.zip'
    checksum       = '0b3827c151f49652a04f2a2f4577f8566ac9ca7beca6ac86f85e737069eccbab'
    checksumType   = 'sha256'

    # 64-bit
    url64bit       = 'https://github.com/terraform-linters/tflint/releases/download/v0.46.1/tflint_windows_amd64.zip'
    checksum64     = 'f68b982dfc2f860ca0aed1efaf6b82e90e1222a78ca16692241937f2e8191327'
    checksumType64 = $checksumType

    # misc
    unziplocation  = "$toolsDir"
}

Install-ChocolateyZipPackage @packageArgs
