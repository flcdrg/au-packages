$packageArgs = @{
  PackageName         = "vault"
  Url                 = "https://releases.hashicorp.com/vault/$($env:ChocolateyPackageVersion)/vault_$($env:ChocolateyPackageVersion)_windows_386.zip"
  UnzipLocation       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
  Url64               = "https://releases.hashicorp.com/vault/$($env:ChocolateyPackageVersion)/vault_$($env:ChocolateyPackageVersion)_windows_amd64.zip"
  Checksum            = '9460548bf345379e17ac2f5993e1354ba982b4922356d88dcf02cfc101a4e03e'
  ChecksumType        = 'sha256'
  Checksum64          = '7ed488aa8bbae5da75cbb909d454c5e86d7ac18389bdd9f844ce58007c6e3ac3'
  version             = $env:ChocolateyPackageVersion
}

Install-ChocolateyZipPackage @packageArgs
