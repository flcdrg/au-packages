$ErrorActionPreference = 'Stop'; # stop on all errors
$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$packageArgs = @{
    packageName    = 'tflint'

    # 32-bit
    url            = 'https://github.com/terraform-linters/tflint/releases/download/v0.55.1/tflint_windows_386.zip'
    checksum       = 'd6d81b16b8d7bbb92e635c18ca368580e3569e86d9cb6ee1c90cf6a993d7a45b'
    checksumType   = 'sha256'

    # 64-bit
    url64bit       = 'https://github.com/terraform-linters/tflint/releases/download/v0.55.1/tflint_windows_amd64.zip'
    checksum64     = '667e8333eed843298ba1fd1120776784c0dacc17de25e253bc8a67b03adbe87d'
    checksumType64 = $checksumType

    # misc
    unziplocation  = "$toolsDir"
}

Install-ChocolateyZipPackage @packageArgs
