$ErrorActionPreference = 'Stop'; # stop on all errors
$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$packageArgs = @{
    packageName    = 'tflint'

    # 32-bit
    url            = 'https://github.com/terraform-linters/tflint/releases/download/v0.50.1/tflint_windows_386.zip'
    checksum       = 'e5feec12264a9054c80a0ab8a9327e944aece948c60116e9ad5cca7958f36e72'
    checksumType   = 'sha256'

    # 64-bit
    url64bit       = 'https://github.com/terraform-linters/tflint/releases/download/v0.50.1/tflint_windows_amd64.zip'
    checksum64     = 'cbe3a481e1b10af919624a38a364759f99f15e9993d781267add17bb3a041276'
    checksumType64 = $checksumType

    # misc
    unziplocation  = "$toolsDir"
}

Install-ChocolateyZipPackage @packageArgs
