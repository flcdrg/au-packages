$packageArgs = @{
  PackageName         = "vault"
  Url                 = "https://releases.hashicorp.com/vault/$($env:ChocolateyPackageVersion)/vault_$($env:ChocolateyPackageVersion)_windows_386.zip"
  UnzipLocation       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
  Url64               = "https://releases.hashicorp.com/vault/$($env:ChocolateyPackageVersion)/vault_$($env:ChocolateyPackageVersion)_windows_amd64.zip"
  Checksum            = 'e7fb2e6cec3342a005ec6cb14107e7eca8198225398c1c056756db1ec4dae885'
  ChecksumType        = 'sha256'
  Checksum64          = '8b080023ca78b2db41e3ab0ab26f72b2bad36c9ec03b21b20bfe289ea5d45855'
  version             = $env:ChocolateyPackageVersion
}

Install-ChocolateyZipPackage @packageArgs
