$packageArgs = @{
  PackageName         = "vault"
  Url                 = "https://releases.hashicorp.com/vault/$($env:ChocolateyPackageVersion)/vault_$($env:ChocolateyPackageVersion)_windows_386.zip"
  UnzipLocation       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
  Url64               = "https://releases.hashicorp.com/vault/$($env:ChocolateyPackageVersion)/vault_$($env:ChocolateyPackageVersion)_windows_amd64.zip"
  Checksum            = 'e5b04a27d23862c9f3ad7c3c8a321177dc63cbfc8d13ebf2c3ec391d1d5fc9fd'
  ChecksumType        = 'sha256'
  Checksum64          = '5e6357e52f75657f9a51f2655d42811b8b129166402ecf2d2dc630ffcd3c8d8f'
  version             = $env:ChocolateyPackageVersion
}

Install-ChocolateyZipPackage @packageArgs
