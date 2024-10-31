$packageArgs = @{
  PackageName         = "vault"
  Url                 = "https://releases.hashicorp.com/vault/$($env:ChocolateyPackageVersion)/vault_$($env:ChocolateyPackageVersion)_windows_386.zip"
  UnzipLocation       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
  Url64               = "https://releases.hashicorp.com/vault/$($env:ChocolateyPackageVersion)/vault_$($env:ChocolateyPackageVersion)_windows_amd64.zip"
  Checksum            = '7a242b06868c5de5a0e37246a78be5e1d78ffabd9866d2fda4db3ae0abe4c9d4'
  ChecksumType        = 'sha256'
  Checksum64          = '73935235e81da711f36b26560d8b47ee62a72d7c8122ada68cdf5fbc6ddacec0'
  version             = $env:ChocolateyPackageVersion
}

Install-ChocolateyZipPackage @packageArgs
