$packageArgs = @{
  PackageName         = "vault"
  Url                 = "https://releases.hashicorp.com/vault/$($env:ChocolateyPackageVersion)/vault_$($env:ChocolateyPackageVersion)_windows_386.zip"
  UnzipLocation       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
  Url64               = "https://releases.hashicorp.com/vault/$($env:ChocolateyPackageVersion)/vault_$($env:ChocolateyPackageVersion)_windows_amd64.zip"
  Checksum            = 'b2922a5916156f38697a99bd8c94574b8ad95b4f5bb87bb63273d7f3c687b7b5'
  ChecksumType        = 'sha256'
  Checksum64          = 'ca3bba637d30ae87df66cffce411f27bfa1fc00a82e4aee2c7e782af370409c5'
  version             = $env:ChocolateyPackageVersion
}

Install-ChocolateyZipPackage @packageArgs
