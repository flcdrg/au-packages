$ErrorActionPreference = 'Stop'; # stop on all errors
$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$packageArgs = @{
    packageName    = 'tflint'

    # 32-bit
    url            = 'https://github.com/terraform-linters/tflint/releases/download/v0.61.0/tflint_windows_386.zip'
    checksum       = '4b48d5134a2736a19d8b293c23c8d9b04ba7d4f8a3d3f69f5a11183243efc772'
    checksumType   = 'sha256'

    # 64-bit
    url64bit       = 'https://github.com/terraform-linters/tflint/releases/download/v0.61.0/tflint_windows_amd64.zip'
    checksum64     = 'f114a26a519f580a9d27204b1210ba5869ed8219d7e23a732d41774d612af3b0'
    checksumType64 = $checksumType

    # misc
    unziplocation  = "$toolsDir"
}

Install-ChocolateyZipPackage @packageArgs
