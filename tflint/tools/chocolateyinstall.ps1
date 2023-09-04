$ErrorActionPreference = 'Stop'; # stop on all errors
$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$packageArgs = @{
    packageName    = 'tflint'

    # 32-bit
    url            = 'https://github.com/terraform-linters/tflint/releases/download/v0.48.0/tflint_windows_386.zip'
    checksum       = 'ccbd7bd639b38ca0ee9e93792d97bad352c194f77d2d580c702730c2574c66a9'
    checksumType   = 'sha256'

    # 64-bit
    url64bit       = 'https://github.com/terraform-linters/tflint/releases/download/v0.48.0/tflint_windows_amd64.zip'
    checksum64     = '1efab7ea19e8adb73cae770e5edabae44a5cebd63baf203a5d3270948db55648'
    checksumType64 = $checksumType

    # misc
    unziplocation  = "$toolsDir"
}

Install-ChocolateyZipPackage @packageArgs
