
$ErrorActionPreference = 'Stop';
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url        = 'https://download.microsoft.com/download/F/6/7/F673709C-D371-4A64-8BF9-C1DD73F60990/ENU/x86/SqlLocalDB.msi'
$url64      = 'https://download.microsoft.com/download/F/6/7/F673709C-D371-4A64-8BF9-C1DD73F60990/ENU/x64/SqlLocalDB.msi'

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  unzipLocation = $toolsDir
  fileType      = 'MSI'
  url           = $url
  url64bit      = $url64

  softwareName  = 'sqlserverlocaldb*'

  checksum      = '1E33A390A58EFC4923A91EFE1A44312E0EE38DAFE2D6DAC8C7367363A9987CA8'
  checksumType  = 'sha256' 
  checksum64    = '5E077F16C4F325F45A13EF4BAFC9D088F6E5EAD53AF5399977ACB1D3BB3404ED'
  checksumType64= 'sha256'

  # MSI
  silentArgs    = "/qn IACCEPTSQLLOCALDBLICENSETERMS=YES /l*v `"$($env:TEMP)\$($packageName).$($env:chocolateyPackageVersion).MsiInstall.log`""
  validExitCodes= @(0, 3010)

}

Install-ChocolateyPackage @packageArgs
