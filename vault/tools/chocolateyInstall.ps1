$packageArgs = @{
  PackageName         = "vault"
  Url                 = "https://releases.hashicorp.com/vault/$($env:ChocolateyPackageVersion)/vault_$($env:ChocolateyPackageVersion)_windows_386.zip"
  UnzipLocation       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
  Url64               = "https://releases.hashicorp.com/vault/$($env:ChocolateyPackageVersion)/vault_$($env:ChocolateyPackageVersion)_windows_amd64.zip"
  Checksum            = 'c98a0c8eb527efb8eec7c109165e5857aa1f2d0230f0dcac211d9ec7053c8ba5'
  ChecksumType        = 'sha256'
  Checksum64          = '1e56f46b292f0a034f50c4b82d98ce8a845b42f1c13ca8e282c5604aac5699f7'
  version             = $env:ChocolateyPackageVersion
}

Install-ChocolateyZipPackage @packageArgs
