$packageArgs = @{
  PackageName         = "vault"
  Url                 = "https://releases.hashicorp.com/vault/$($env:ChocolateyPackageVersion)/vault_$($env:ChocolateyPackageVersion)_windows_386.zip"
  UnzipLocation       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
  Url64               = "https://releases.hashicorp.com/vault/$($env:ChocolateyPackageVersion)/vault_$($env:ChocolateyPackageVersion)_windows_amd64.zip"
  Checksum            = '941eee316ac7a7c04a4011f8fee3889477d4bf8a549f3e53ca3c0b8b9e3c8175'
  ChecksumType        = 'sha256'
  Checksum64          = '7cf50397a046401ee9d2c9035f0f9bbc9edc95c4bf24666294433f4fd99a875d'
  version             = $env:ChocolateyPackageVersion
}

Install-ChocolateyZipPackage @packageArgs
