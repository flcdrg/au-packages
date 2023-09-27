$packageArgs = @{
  PackageName         = "vault"
  Url                 = "https://releases.hashicorp.com/vault/$($env:ChocolateyPackageVersion)/vault_$($env:ChocolateyPackageVersion)_windows_386.zip"
  UnzipLocation       = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
  Url64               = "https://releases.hashicorp.com/vault/$($env:ChocolateyPackageVersion)/vault_$($env:ChocolateyPackageVersion)_windows_amd64.zip"
  Checksum            = 'ad94fd7415b9eab7eab1dde28dbab4e102b757959eb32f1bae55362106e59a80'
  ChecksumType        = 'sha256'
  Checksum64          = '69b4a6fab1a9bdf3a619a4cf358dfb824e5d1facb2f5f039a94aa12f336342a6'
  version             = $env:ChocolateyPackageVersion
}

Install-ChocolateyZipPackage @packageArgs
