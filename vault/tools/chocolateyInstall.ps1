$packageArgs = @{
  PackageName         = "vault"
  Url                 = "https://releases.hashicorp.com/vault/$($env:ChocolateyPackageVersion)/vault_$($env:ChocolateyPackageVersion)_windows_386.zip"
  UnzipLocation       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
  Url64               = "https://releases.hashicorp.com/vault/$($env:ChocolateyPackageVersion)/vault_$($env:ChocolateyPackageVersion)_windows_amd64.zip"
  Checksum            = '30bccbdc9a27b6611485fc5217faf9f70efb1ba870b90f7373b25fb3b5ce3484'
  ChecksumType        = 'sha256'
  Checksum64          = '516e5f54061b716491abdc59def3d62a08d34c1e1b2e949adf4df0906ecf6c67'
  version             = $env:ChocolateyPackageVersion
}

Install-ChocolateyZipPackage @packageArgs
