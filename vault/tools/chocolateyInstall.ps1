$packageArgs = @{
  PackageName         = "vault"
  Url                 = "https://releases.hashicorp.com/vault/$($env:ChocolateyPackageVersion)/vault_$($env:ChocolateyPackageVersion)_windows_386.zip"
  UnzipLocation       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
  Url64               = "https://releases.hashicorp.com/vault/$($env:ChocolateyPackageVersion)/vault_$($env:ChocolateyPackageVersion)_windows_amd64.zip"
  Checksum            = '1d5ce84d89c23a68c5eb5079e65b61069033877dfc4d10d3ea8b9a7c3bc32f88'
  ChecksumType        = 'sha256'
  Checksum64          = 'e07a39059d7c7380d6dc776fb5bee2183cbc3344cf9387d4cf11309b83c0dce3'
  version             = $env:ChocolateyPackageVersion
}

Install-ChocolateyZipPackage @packageArgs
