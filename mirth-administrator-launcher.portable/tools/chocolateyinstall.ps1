$ErrorActionPreference = 'Stop';
$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  fileType      = 'zip'
  
  validExitCodes= @(0)
  url           = "https://s3.us-east-1.amazonaws.com/downloads.mirthcorp.com/connect-client-launcher/mirth-administrator-launcher-1.4.1-windows-x32.zip"
  checksum      = '59A7DF44694F91943977D35AE0F3AF483A13F924A3EA77EF663B8D7343DED4FD'
  checksumType  = 'sha256'
  url64bit      = "https://s3.us-east-1.amazonaws.com/downloads.mirthcorp.com/connect-client-launcher/mirth-administrator-launcher-1.4.1-windows-x64.zip"
  checksum64    = '23CCC489600CCEB321269614E910D46CE7574E33572DB73EBB12294B0E2E0B43'
  checksumType64= 'sha256'
  destination   = $toolsDir
}

Install-ChocolateyZipPackage @packageArgs

$files = get-childitem $toolsDir -include *.exe -recurse

foreach ($file in $files) {
  if (!($file.Name -eq "launcher.exe")) {
    #generate an ignore file
    New-Item "$file.ignore" -type file -force | Out-Null
  }
}