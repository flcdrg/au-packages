$packageArgs = @{
  PackageName         = "vault"
  Url                 = "https://releases.hashicorp.com/vault/$($env:ChocolateyPackageVersion)/vault_$($env:ChocolateyPackageVersion)_windows_386.zip"
  UnzipLocation       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
  Url64               = "https://releases.hashicorp.com/vault/$($env:ChocolateyPackageVersion)/vault_$($env:ChocolateyPackageVersion)_windows_amd64.zip"
  Checksum            = 'a6af2a87378212dcdfdc1c0ef3e67e63831c89efff722a1fa4db824c1f7b5ab6'
  ChecksumType        = 'sha256'
  Checksum64          = '2b95c8dfab77c9915b4471366e3fc348a41e96d60072cec14b30ae9860c8dd1f'
  version             = $env:ChocolateyPackageVersion
}

Install-ChocolateyZipPackage @packageArgs
