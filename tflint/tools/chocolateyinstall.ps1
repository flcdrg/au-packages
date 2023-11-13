$ErrorActionPreference = 'Stop'; # stop on all errors
$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$packageArgs = @{
    packageName    = 'tflint'

    # 32-bit
    url            = 'https://github.com/terraform-linters/tflint/releases/download/v0.49.0/tflint_windows_386.zip'
    checksum       = 'cb64f78afca67b3a567a0bc39942b22597d0d39003415ead9f2fbe329ce50619'
    checksumType   = 'sha256'

    # 64-bit
    url64bit       = 'https://github.com/terraform-linters/tflint/releases/download/v0.49.0/tflint_windows_amd64.zip'
    checksum64     = '215b2f3658c1e272a6675a13593c874439bdf20d6dc1ff3d02ce446e3ce8782d'
    checksumType64 = $checksumType

    # misc
    unziplocation  = "$toolsDir"
}

Install-ChocolateyZipPackage @packageArgs
