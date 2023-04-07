$ErrorActionPreference = 'Stop'; # stop on all errors
$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$packageArgs = @{
    packageName    = 'tflint'

    # 32-bit
    url            = 'https://github.com/terraform-linters/tflint/releases/download/v0.45.0/tflint_windows_386.zip'
    checksum       = '847b252b5aa8d52b1f2b018d19e8fb829028815f1b3ebd1b68e80789e4befff6'
    checksumType   = 'sha256'

    # 64-bit
    url64bit       = 'https://github.com/terraform-linters/tflint/releases/download/v0.45.0/tflint_windows_amd64.zip'
    checksum64     = 'b9332372d40f47ad19f5b3557fedebc02cdc368e8b390a7810f359d97e03ec42'
    checksumType64 = $checksumType

    # misc
    unziplocation  = "$toolsDir"
}

Install-ChocolateyZipPackage @packageArgs
