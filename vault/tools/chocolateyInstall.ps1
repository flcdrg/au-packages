$packageArgs = @{
  PackageName         = "vault"
  Url                 = "https://releases.hashicorp.com/vault/$($env:ChocolateyPackageVersion)/vault_$($env:ChocolateyPackageVersion)_windows_386.zip"
  UnzipLocation       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
  Url64               = "https://releases.hashicorp.com/vault/$($env:ChocolateyPackageVersion)/vault_$($env:ChocolateyPackageVersion)_windows_amd64.zip"
  Checksum            = '18b32e3aeea1ea1ac3c369347f09681abc1599b966be27fd1f5308aeb95ce57f'
  ChecksumType        = 'sha256'
  Checksum64          = '23dc7f8928d755c5b885a82bcc69323616bb856a28973c0dad7aaa24ce0a7d6d'
  version             = $env:ChocolateyPackageVersion
}

Install-ChocolateyZipPackage @packageArgs
