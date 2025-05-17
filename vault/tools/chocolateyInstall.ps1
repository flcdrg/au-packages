$packageArgs = @{
  PackageName         = "vault"
  Url                 = "https://releases.hashicorp.com/vault/$($env:ChocolateyPackageVersion)/vault_$($env:ChocolateyPackageVersion)_windows_386.zip"
  UnzipLocation       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
  Url64               = "https://releases.hashicorp.com/vault/$($env:ChocolateyPackageVersion)/vault_$($env:ChocolateyPackageVersion)_windows_amd64.zip"
  Checksum            = '01c9dc2e56b62bc3aaf0fbfc4f816342b8117009a17418cfc09386ee06ebecd5'
  ChecksumType        = 'sha256'
  Checksum64          = '5ed8c25ef8763f794a1ec4a5be5bb3488fc3cc8c926290a0f815ddbb4b38ad4d'
  version             = $env:ChocolateyPackageVersion
}

Install-ChocolateyZipPackage @packageArgs
