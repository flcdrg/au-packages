$packageArgs = @{
  PackageName         = "vault"
  Url                 = "https://releases.hashicorp.com/vault/$($env:ChocolateyPackageVersion)/vault_$($env:ChocolateyPackageVersion)_windows_386.zip"
  UnzipLocation       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
  Url64               = "https://releases.hashicorp.com/vault/$($env:ChocolateyPackageVersion)/vault_$($env:ChocolateyPackageVersion)_windows_amd64.zip"
  Checksum            = '3355de7e36cd5bc2a92828793b49dea9f2193f1eedf8a0fe62099947efd774a0'
  ChecksumType        = 'sha256'
  Checksum64          = 'b162bdcf3e75ff78c4df88fa6d73d46d174ee518c37a52ac296c7dc6daf50564'
  version             = $env:ChocolateyPackageVersion
}

Install-ChocolateyZipPackage @packageArgs
