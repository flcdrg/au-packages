$ErrorActionPreference = 'Stop'; # stop on all errors
$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$packageArgs = @{
    packageName    = 'tflint'

    # 32-bit
    url            = 'https://github.com/terraform-linters/tflint/releases/download/v0.63.1/tflint_windows_386.zip'
    checksum       = '401e97df8675d7b42e8dbfeafd1eb93a4152c19a6e305e6b94c8d7cda1b3d28c'
    checksumType   = 'sha256'

    # 64-bit
    url64bit       = 'https://github.com/terraform-linters/tflint/releases/download/v0.63.1/tflint_windows_amd64.zip'
    checksum64     = '5fbfb643b83c4ad489bde15a0e0d46e53dc9aa8dfa76d25da3c4bd2698a41a19'
    checksumType64 = $checksumType

    # misc
    unziplocation  = "$toolsDir"
}

Install-ChocolateyZipPackage @packageArgs
