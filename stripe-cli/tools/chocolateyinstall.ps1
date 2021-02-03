$ErrorActionPreference = 'Stop';
$toolsDir     = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$fileLocation = ''

#Based on NO DETECTION IN PRO
$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  softwareName  = 'stripe-cli*'
  fileType      = 'zip'
  silentArgs    = "/s"
  #OTHERS
  # Uncomment matching EXE type (sorted by most to least common)
  #$silentArgs = '/S'           # NSIS
  #silentArgs   = '/VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-' # Inno Setup
  #silentArgs   = '/s'           # InstallShield
  #silentArgs   = '/s /v"/qn"' # InstallShield with MSI
  #silentArgs   = '/s'           # Wise InstallMaster
  #silentArgs   = '-s'           # Squirrel
  #silentArgs   = '-q'           # Install4j
  #silentArgs   = '-s'           # Ghost
  # Note that some installers, in addition to the silentArgs above, may also need assistance of AHK to achieve silence.
  #silentArgs   = ''             # none; make silent with input macro script like AutoHotKey (AHK)
                                 #       https://chocolatey.org/packages/autohotkey.portable
  
  validExitCodes= @(0) #please insert other valid exit codes here
  url           = "https://github.com/stripe/stripe-cli/releases/download/v1.5.8/stripe_1.5.8_windows_x86_64.zip"  #download URL, HTTPS preferrred
  checksum      = 'B96E65681184661E51F02726DB98AAD03DB6AADA6420CC8018AC1AA0FF48504C'
  checksumType  = 'sha256'
  url64bit      = ""   # 64bit URL here (HTTPS preferred) or remove - if installer contains both architectures (very rare), use $url
  checksum64    = ''
  checksumType64= 'sha256'
  destination   = $toolsDir
}

Install-ChocolateyZipPackage @packageArgs

## See https://chocolatey.org/docs/helpers-reference

