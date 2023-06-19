$ErrorActionPreference = 'Stop'; # stop on all errors
$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$packageArgs = @{
    packageName    = 'tflint'

    # 32-bit
    url            = 'https://github.com/terraform-linters/tflint/releases/download/v0.47.0/tflint_windows_386.zip'
    checksum       = '470ed46a9dcf8f0a7f001de790f191474b47c9229dafd8dff3531cbdb1a4460f'
    checksumType   = 'sha256'

    # 64-bit
    url64bit       = 'https://github.com/terraform-linters/tflint/releases/download/v0.47.0/tflint_windows_amd64.zip'
    checksum64     = '8d3b451bca731760aa790735f70d399080242bbd27c666248a113168c3bdb602'
    checksumType64 = $checksumType

    # misc
    unziplocation  = "$toolsDir"
}

Install-ChocolateyZipPackage @packageArgs
