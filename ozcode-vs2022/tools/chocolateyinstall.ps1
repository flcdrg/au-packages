$ErrorActionPreference = 'Stop';

$fileName     = 'OzCode_4.0.0.22253.vsix'
$checksum     = 'cbfe4c3d6c372051600fe74eeb64d86ade958e9a8a5875342737902cec2069db'

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  url           = "https://downloads.oz-code.com/files/$fileName"
  checksum      = $checksum
  checksumType  = 'sha256'
}

Install-VisualStudioVsixExtension @packageArgs
