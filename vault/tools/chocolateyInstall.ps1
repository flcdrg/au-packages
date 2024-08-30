$packageArgs = @{
  PackageName         = "vault"
  Url                 = "https://releases.hashicorp.com/vault/$($env:ChocolateyPackageVersion)/vault_$($env:ChocolateyPackageVersion)_windows_386.zip"
  UnzipLocation       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
  Url64               = "https://releases.hashicorp.com/vault/$($env:ChocolateyPackageVersion)/vault_$($env:ChocolateyPackageVersion)_windows_amd64.zip"
  Checksum            = '830f0f6be0d2a87295e367afd05290ca9aaf7a4616e839ed8a814d7fc2d7c19c'
  ChecksumType        = 'sha256'
  Checksum64          = 'f25ce7fbb15473bd61ea2eeef005518336041a2b955c31df04fbb9222cd3a139'
  version             = $env:ChocolateyPackageVersion
}

Install-ChocolateyZipPackage @packageArgs
