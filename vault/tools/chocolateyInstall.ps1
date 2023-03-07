$packageArgs = @{
  PackageName         = "vault"
  Url                 = "https://releases.hashicorp.com/vault/$($env:ChocolateyPackageVersion)/vault_$($env:ChocolateyPackageVersion)_windows_386.zip"
  UnzipLocation       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
  Url64               = "https://releases.hashicorp.com/vault/$($env:ChocolateyPackageVersion)/vault_$($env:ChocolateyPackageVersion)_windows_amd64.zip"
  Checksum            = '9e06b0a2ff00ec95662aa86c2bdfb7dddae6e4dec1c4b205baefb9f724fce58e'
  ChecksumType        = 'sha256'
  Checksum64          = '158152d48e0798f19e7ecfc74ac35ec1edf260995bb3e6baf4bebafb78b9f047'
  version             = $env:ChocolateyPackageVersion
}

Install-ChocolateyZipPackage @packageArgs
