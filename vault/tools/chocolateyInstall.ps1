$packageArgs = @{
  PackageName         = "vault"
  Url                 = "https://releases.hashicorp.com/vault/$($env:ChocolateyPackageVersion)/vault_$($env:ChocolateyPackageVersion)_windows_386.zip"
  UnzipLocation       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
  Url64               = "https://releases.hashicorp.com/vault/$($env:ChocolateyPackageVersion)/vault_$($env:ChocolateyPackageVersion)_windows_amd64.zip"
  Checksum            = 'befc1012cd05d859ebc24f58f6acc239adf2a4d135857c9ce3aae21af0c712a4'
  ChecksumType        = 'sha256'
  Checksum64          = 'c797b5dd29e62c9fe4fee901b55d44951010a14a40d9007aa32d4c86c849d187'
  version             = $env:ChocolateyPackageVersion
}

Install-ChocolateyZipPackage @packageArgs
