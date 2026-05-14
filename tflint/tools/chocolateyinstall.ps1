$ErrorActionPreference = 'Stop'; # stop on all errors
$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$packageArgs = @{
    packageName    = 'tflint'

    # 32-bit
    url            = 'https://github.com/terraform-linters/tflint/releases/download/v0.62.1/tflint_windows_386.zip'
    checksum       = '47a0ada2060a6bcda9c2f40419bd82795a2bd4e2855832298f14ad2b7a0fe536'
    checksumType   = 'sha256'

    # 64-bit
    url64bit       = 'https://github.com/terraform-linters/tflint/releases/download/v0.62.1/tflint_windows_amd64.zip'
    checksum64     = 'bef472fd62dcbdb616bbdf67800f1bcf8db64598529c09610154686555180edd'
    checksumType64 = $checksumType

    # misc
    unziplocation  = "$toolsDir"
}

Install-ChocolateyZipPackage @packageArgs
