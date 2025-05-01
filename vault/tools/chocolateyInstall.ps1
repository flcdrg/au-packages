$packageArgs = @{
  PackageName         = "vault"
  Url                 = "https://releases.hashicorp.com/vault/$($env:ChocolateyPackageVersion)/vault_$($env:ChocolateyPackageVersion)_windows_386.zip"
  UnzipLocation       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
  Url64               = "https://releases.hashicorp.com/vault/$($env:ChocolateyPackageVersion)/vault_$($env:ChocolateyPackageVersion)_windows_amd64.zip"
  Checksum            = '4151e2b94480aaa253481dd55180d89e6b1eeac1e0d31efa042a5e74893ba50a'
  ChecksumType        = 'sha256'
  Checksum64          = 'd3eb297db503625c308f365f63d2c0d6914471ce9313af47f9fec9bf4b58fbc9'
  version             = $env:ChocolateyPackageVersion
}

Install-ChocolateyZipPackage @packageArgs
