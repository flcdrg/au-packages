$packageArgs = @{
  PackageName         = "vault"
  Url                 = "https://releases.hashicorp.com/vault/$($env:ChocolateyPackageVersion)/vault_$($env:ChocolateyPackageVersion)_windows_386.zip"
  UnzipLocation       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
  Url64               = "https://releases.hashicorp.com/vault/$($env:ChocolateyPackageVersion)/vault_$($env:ChocolateyPackageVersion)_windows_amd64.zip"
  Checksum            = 'afb6920b0c5c52cf6e4dc7738cfbeb14102d9a5737aaf5b43b87da3754028aa2'
  ChecksumType        = 'sha256'
  Checksum64          = 'e23c6aeedfa130bf74e1062959c007d54042ff7adb7d7349d194eb089d86155b'
  version             = $env:ChocolateyPackageVersion
}

Install-ChocolateyZipPackage @packageArgs
