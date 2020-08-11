$ErrorActionPreference = 'Stop';
$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  ZipFileName   = 'upsource-2020.1.1802.zip'
}

Uninstall-ChocolateyZipPackage @packageArgs
