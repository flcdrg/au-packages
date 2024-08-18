$ErrorActionPreference = 'Stop'; # stop on all errors
$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$packageArgs = @{
    packageName    = 'tflint'

    # 32-bit
    url            = 'https://github.com/terraform-linters/tflint/releases/download/v0.53.0/tflint_windows_386.zip'
    checksum       = '6f253074bf0b393c239218f53ee7247cc342b9d84b52b0a9fcc9a8bfc0ffff32'
    checksumType   = 'sha256'

    # 64-bit
    url64bit       = 'https://github.com/terraform-linters/tflint/releases/download/v0.53.0/tflint_windows_amd64.zip'
    checksum64     = '76c0fb7fcec89cfb3661fe5840736d74bacbfd89bf1829bd788cf47a1c9ee1ad'
    checksumType64 = $checksumType

    # misc
    unziplocation  = "$toolsDir"
}

Install-ChocolateyZipPackage @packageArgs
