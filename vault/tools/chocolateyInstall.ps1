$packageArgs = @{
  PackageName         = "vault"
  Url                 = "https://releases.hashicorp.com/vault/$($env:ChocolateyPackageVersion)/vault_$($env:ChocolateyPackageVersion)_windows_386.zip"
  UnzipLocation       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
  Url64               = "https://releases.hashicorp.com/vault/$($env:ChocolateyPackageVersion)/vault_$($env:ChocolateyPackageVersion)_windows_amd64.zip"
  Checksum            = '47bafd6fca4159d2c0e723f31e4dc0f29ee73344dd10230253497c35ef3e1400'
  ChecksumType        = 'sha256'
  Checksum64          = 'e3edfe135a6bdd0c14c4452326e0517f55a5eb9ece6499059c81f5f131206c85'
  version             = $env:ChocolateyPackageVersion
}

Install-ChocolateyZipPackage @packageArgs
