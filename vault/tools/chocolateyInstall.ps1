$packageArgs = @{
  PackageName         = "vault"
  Url                 = "https://releases.hashicorp.com/vault/$($env:ChocolateyPackageVersion)/vault_$($env:ChocolateyPackageVersion)_windows_386.zip"
  UnzipLocation       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
  Url64               = "https://releases.hashicorp.com/vault/$($env:ChocolateyPackageVersion)/vault_$($env:ChocolateyPackageVersion)_windows_amd64.zip"
  Checksum            = '973750fc2f1567b051f26112a383488bd92f6aaed4eb8e15c82aa225f1de717f'
  ChecksumType        = 'sha256'
  Checksum64          = 'a05bc197946951c131c907aa553829746b5d7fc8598879d3e3a9770b9488ebfc'
  version             = $env:ChocolateyPackageVersion
}

Install-ChocolateyZipPackage @packageArgs
