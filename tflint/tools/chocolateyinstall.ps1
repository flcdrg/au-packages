$ErrorActionPreference = 'Stop'; # stop on all errors
$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$packageArgs = @{
    packageName    = 'tflint'

    # 32-bit
    url            = 'https://github.com/terraform-linters/tflint/releases/download/v0.50.2/tflint_windows_386.zip'
    checksum       = '645e7cbf2276366ffb717d6935f51a56641551f5ff19281336f70cffd981f097'
    checksumType   = 'sha256'

    # 64-bit
    url64bit       = 'https://github.com/terraform-linters/tflint/releases/download/v0.50.2/tflint_windows_amd64.zip'
    checksum64     = 'd90735fff73ef5637ef5148f75a42cd644d3b5192a26325d0163707a83c55806'
    checksumType64 = $checksumType

    # misc
    unziplocation  = "$toolsDir"
}

Install-ChocolateyZipPackage @packageArgs
