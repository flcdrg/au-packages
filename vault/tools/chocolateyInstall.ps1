$packageArgs = @{
  PackageName         = "vault"
  Url                 = "https://releases.hashicorp.com/vault/$($env:ChocolateyPackageVersion)/vault_$($env:ChocolateyPackageVersion)_windows_386.zip"
  UnzipLocation       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
  Url64               = "https://releases.hashicorp.com/vault/$($env:ChocolateyPackageVersion)/vault_$($env:ChocolateyPackageVersion)_windows_amd64.zip"
  Checksum            = '47c6a49a78cc1702655fb83c0913730bbc0e7b4aa60161c884cf49ad5c53cb5c'
  ChecksumType        = 'sha256'
  Checksum64          = 'defd708e5db4c8ce989729d17a53bab78f0b730fde2fefc76b289e73c61dcdca'
  version             = $env:ChocolateyPackageVersion
}

Install-ChocolateyZipPackage @packageArgs
