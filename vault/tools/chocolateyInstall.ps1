$packageArgs = @{
  PackageName         = "vault"
  Url                 = "https://releases.hashicorp.com/vault/$($env:ChocolateyPackageVersion)/vault_$($env:ChocolateyPackageVersion)_windows_386.zip"
  UnzipLocation       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
  Url64               = "https://releases.hashicorp.com/vault/$($env:ChocolateyPackageVersion)/vault_$($env:ChocolateyPackageVersion)_windows_amd64.zip"
  Checksum            = '7d3b153267099af245319b6bff3c9925547fe6fc7d5bb46e07a8a2b5acf61ce1'
  ChecksumType        = 'sha256'
  Checksum64          = '90c6223d54b9fccd5f0ae33dd264e5a1bc4972546da8e93e6f2bb1b02b3fed80'
  version             = $env:ChocolateyPackageVersion
}

Install-ChocolateyZipPackage @packageArgs
