$packageArgs = @{
  PackageName         = "vault"
  Url                 = "https://releases.hashicorp.com/vault/$($env:ChocolateyPackageVersion)/vault_$($env:ChocolateyPackageVersion)_windows_386.zip"
  UnzipLocation       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
  Url64               = "https://releases.hashicorp.com/vault/$($env:ChocolateyPackageVersion)/vault_$($env:ChocolateyPackageVersion)_windows_amd64.zip"
  Checksum            = 'd81c078dbcbd15ff8ffa66b905243e7acc66c27a5a3408a88575d83c09431f29'
  ChecksumType        = 'sha256'
  Checksum64          = '4ccd8fd45607df52231ec6bd4fa0131ae9e83d908f9f8af64a4babc491d76062'
  version             = $env:ChocolateyPackageVersion
}

Install-ChocolateyZipPackage @packageArgs
