$packageArgs = @{
  PackageName         = "vault"
  Url                 = "https://releases.hashicorp.com/vault/$($env:ChocolateyPackageVersion)/vault_$($env:ChocolateyPackageVersion)_windows_386.zip"
  UnzipLocation       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
  Url64               = "https://releases.hashicorp.com/vault/$($env:ChocolateyPackageVersion)/vault_$($env:ChocolateyPackageVersion)_windows_amd64.zip"
  Checksum            = 'bacb689e7ea8fdba61f05bc7ee29ffac8071276842b4eea15972771cc98219e6'
  ChecksumType        = 'sha256'
  Checksum64          = '21e4c61348a3ff3346ba7138c5ed4514e3b09d827a830f75c63ddfdd7af27bf0'
  version             = $env:ChocolateyPackageVersion
}

Install-ChocolateyZipPackage @packageArgs
