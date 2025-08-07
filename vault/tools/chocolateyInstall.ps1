$packageArgs = @{
  PackageName         = "vault"
  Url                 = "https://releases.hashicorp.com/vault/$($env:ChocolateyPackageVersion)/vault_$($env:ChocolateyPackageVersion)_windows_386.zip"
  UnzipLocation       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
  Url64               = "https://releases.hashicorp.com/vault/$($env:ChocolateyPackageVersion)/vault_$($env:ChocolateyPackageVersion)_windows_amd64.zip"
  Checksum            = '7cf9adea0a5d183bb73f2610d5b5f28582a450b818bbd6a99761663bdcc52b90'
  ChecksumType        = 'sha256'
  Checksum64          = 'a85f7cb46d7e03bd2dbe969e116c8b037f3ec1a4b116d3ac6a0e9c842e1ddc29'
  version             = $env:ChocolateyPackageVersion
}

Install-ChocolateyZipPackage @packageArgs
