$packageArgs = @{
  PackageName         = "vault"
  Url                 = "https://releases.hashicorp.com/vault/$($env:ChocolateyPackageVersion)/vault_$($env:ChocolateyPackageVersion)_windows_386.zip"
  UnzipLocation       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
  Url64               = "https://releases.hashicorp.com/vault/$($env:ChocolateyPackageVersion)/vault_$($env:ChocolateyPackageVersion)_windows_amd64.zip"
  Checksum            = 'fa754e02e5ed85d59c53552b0bb1bf68480ebdb14882f7ef35bd62f2a26ad33e'
  ChecksumType        = 'sha256'
  Checksum64          = '5701eb07fe076bd7c8c06e2c2193f22e3334e1e3eec15b550053dfb5f5d6bf41'
  version             = $env:ChocolateyPackageVersion
}

Install-ChocolateyZipPackage @packageArgs
