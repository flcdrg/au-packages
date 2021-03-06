$ErrorActionPreference = 'Stop';

$fileName     = 'OzCode_4.0.0.19540.vsix'
$checksum     = '7da5324664c2a700eb726eff1d41f6dc0b00fe2c60cd6f36a2956bee664441b9'

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  url           = "https://downloads.oz-code.com/files/$fileName"
  checksum      = $checksum
  checksumType  = 'sha256'
}

Install-VisualStudioVsixExtension @packageArgs
