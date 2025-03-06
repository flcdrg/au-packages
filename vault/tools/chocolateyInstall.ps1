$packageArgs = @{
  PackageName         = "vault"
  Url                 = "https://releases.hashicorp.com/vault/$($env:ChocolateyPackageVersion)/vault_$($env:ChocolateyPackageVersion)_windows_386.zip"
  UnzipLocation       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
  Url64               = "https://releases.hashicorp.com/vault/$($env:ChocolateyPackageVersion)/vault_$($env:ChocolateyPackageVersion)_windows_amd64.zip"
  Checksum            = 'f1d03346fef1d726a268f4063bfa41b48a356c4d4c6f6cae6cf234049b81cf79'
  ChecksumType        = 'sha256'
  Checksum64          = '4a288f258f9e55caaef494d4bf4d20d885632e49d9883c8dc4f059e64d9aa00d'
  version             = $env:ChocolateyPackageVersion
}

Install-ChocolateyZipPackage @packageArgs
