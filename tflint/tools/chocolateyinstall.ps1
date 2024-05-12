$ErrorActionPreference = 'Stop'; # stop on all errors
$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$packageArgs = @{
    packageName    = 'tflint'

    # 32-bit
    url            = 'https://github.com/terraform-linters/tflint/releases/download/v0.51.1/tflint_windows_386.zip'
    checksum       = '7631af7f6a441903cb280e320cc3260e8a4585d73db724bbd15cd09bc77769da'
    checksumType   = 'sha256'

    # 64-bit
    url64bit       = 'https://github.com/terraform-linters/tflint/releases/download/v0.51.1/tflint_windows_amd64.zip'
    checksum64     = '4c46bbef6181145b451249eb5161ffae49ccaa4b59054e9943911b4d9b7c38c7'
    checksumType64 = $checksumType

    # misc
    unziplocation  = "$toolsDir"
}

Install-ChocolateyZipPackage @packageArgs
