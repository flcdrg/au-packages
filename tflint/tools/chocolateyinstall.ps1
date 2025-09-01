$ErrorActionPreference = 'Stop'; # stop on all errors
$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$packageArgs = @{
    packageName    = 'tflint'

    # 32-bit
    url            = 'https://github.com/terraform-linters/tflint/releases/download/v0.59.1/tflint_windows_386.zip'
    checksum       = '381e9faa9aff787590a7110587aa85b5a16fdeffade1fa880dda83f46a36814c'
    checksumType   = 'sha256'

    # 64-bit
    url64bit       = 'https://github.com/terraform-linters/tflint/releases/download/v0.59.1/tflint_windows_amd64.zip'
    checksum64     = '2d92018dd301852069d631a860d447458a1f75fcc66b040926a1ded7647590a9'
    checksumType64 = $checksumType

    # misc
    unziplocation  = "$toolsDir"
}

Install-ChocolateyZipPackage @packageArgs
