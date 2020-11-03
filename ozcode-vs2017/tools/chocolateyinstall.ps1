$ErrorActionPreference = 'Stop';

$fileName     = 'OzCode_4.0.0.3513.vsix'
$checksum     = '770d6b284e796fba77a43d53b56258f3499d57bcb621c98da68fec901cc36821'

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  url           = "https://downloads.oz-code.com/files/$fileName"
  checksum      = $checksum
  checksumType  = 'sha256'
}

Install-VisualStudioVsixExtension @packageArgs
