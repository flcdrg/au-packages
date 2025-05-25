$ErrorActionPreference = 'Stop'; # stop on all errors
$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$packageArgs = @{
    packageName    = 'tflint'

    # 32-bit
    url            = 'https://github.com/terraform-linters/tflint/releases/download/v0.58.0/tflint_windows_386.zip'
    checksum       = '78eb37da4a4b257e255f38081c10884ebfa810d75f8418f947f401585475b23e'
    checksumType   = 'sha256'

    # 64-bit
    url64bit       = 'https://github.com/terraform-linters/tflint/releases/download/v0.58.0/tflint_windows_amd64.zip'
    checksum64     = '5320933d7b33987b5c452035b84b81d58c5f38cf22ff68d0a3db24ffeb939180'
    checksumType64 = $checksumType

    # misc
    unziplocation  = "$toolsDir"
}

Install-ChocolateyZipPackage @packageArgs
