$packageArgs = @{
  PackageName         = "vault"
  Url                 = "https://releases.hashicorp.com/vault/$($env:ChocolateyPackageVersion)/vault_$($env:ChocolateyPackageVersion)_windows_386.zip"
  UnzipLocation       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
  Url64               = "https://releases.hashicorp.com/vault/$($env:ChocolateyPackageVersion)/vault_$($env:ChocolateyPackageVersion)_windows_amd64.zip"
  Checksum            = 'a99f9d729edaca626ba7a731f672d79972ef5f68320ddcf4780db4cef34cf34f'
  ChecksumType        = 'sha256'
  Checksum64          = '5b4334aa10825ebe692bafcdfc58b21b603a9d8ba4110ff08082cfdc3da02e2c'
  version             = $env:ChocolateyPackageVersion
}

Install-ChocolateyZipPackage @packageArgs
