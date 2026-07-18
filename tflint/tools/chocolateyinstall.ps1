$ErrorActionPreference = 'Stop'; # stop on all errors
$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$packageArgs = @{
    packageName    = 'tflint'

    # 32-bit
    url            = 'https://github.com/terraform-linters/tflint/releases/download/v0.64.0/tflint_windows_386.zip'
    checksum       = '06f0210a69b87d6ddfd78611030d7b5c62d42b88fd121e71000b93138f732167'
    checksumType   = 'sha256'

    # 64-bit
    url64bit       = 'https://github.com/terraform-linters/tflint/releases/download/v0.64.0/tflint_windows_amd64.zip'
    checksum64     = 'fb42fb859d844b156a8ea9d3363078c4d8b85ca78782e60876b08c9b8e59f303'
    checksumType64 = $checksumType

    # misc
    unziplocation  = "$toolsDir"
}

Install-ChocolateyZipPackage @packageArgs
