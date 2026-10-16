$packageArgs = @{
  PackageName         = "vault"
  Url                 = "https://releases.hashicorp.com/vault/$($env:ChocolateyPackageVersion)/vault_$($env:ChocolateyPackageVersion)_windows_386.zip"
  UnzipLocation       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
  Url64               = "https://releases.hashicorp.com/vault/$($env:ChocolateyPackageVersion)/vault_$($env:ChocolateyPackageVersion)_windows_amd64.zip"
  Checksum            = 'f8572de60fe40a6daaf7f5d2d09c3cb52a5d16ea5f637ecc2f51758dd37ce861'
  ChecksumType        = 'sha256'
  Checksum64          = '42264fc35dd6228dd13ade58a6e501bf1aa4910fa368b709dc9dfa23a68e537e'
  version             = $env:ChocolateyPackageVersion
}

Install-ChocolateyZipPackage @packageArgs
