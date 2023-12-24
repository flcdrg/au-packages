$ErrorActionPreference = 'Stop'; # stop on all errors
$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$packageArgs = @{
    packageName    = 'tflint'

    # 32-bit
    url            = 'https://github.com/terraform-linters/tflint/releases/download/v0.50.0/tflint_windows_386.zip'
    checksum       = '31dc12e5aafc1f34e378a96cd697f324cf912467d7effdcbc059eedefac2fe86'
    checksumType   = 'sha256'

    # 64-bit
    url64bit       = 'https://github.com/terraform-linters/tflint/releases/download/v0.50.0/tflint_windows_amd64.zip'
    checksum64     = '8ddc65037db0d9bbb5778ba4a5b6751c24460a9e8c8d5da653f73dce80ba87e8'
    checksumType64 = $checksumType

    # misc
    unziplocation  = "$toolsDir"
}

Install-ChocolateyZipPackage @packageArgs
