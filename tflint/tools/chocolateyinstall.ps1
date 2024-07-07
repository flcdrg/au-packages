$ErrorActionPreference = 'Stop'; # stop on all errors
$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$packageArgs = @{
    packageName    = 'tflint'

    # 32-bit
    url            = 'https://github.com/terraform-linters/tflint/releases/download/v0.52.0/tflint_windows_386.zip'
    checksum       = '2ce6fd6f6bdc6f487db0b7be1de69ad03c24b56977e6bf390aef0783a0732cd0'
    checksumType   = 'sha256'

    # 64-bit
    url64bit       = 'https://github.com/terraform-linters/tflint/releases/download/v0.52.0/tflint_windows_amd64.zip'
    checksum64     = 'fed6ff15ee10db34a23044ac0d4da8fdc1f2f3663b32ec85d388374dd95670aa'
    checksumType64 = $checksumType

    # misc
    unziplocation  = "$toolsDir"
}

Install-ChocolateyZipPackage @packageArgs
