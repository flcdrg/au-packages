#Requires -Version 5.0
#Requires -Modules AU
[cmdletbinding()]
param (
  [switch]$Force
)

$ErrorActionPreference = 'Stop'

$obsNdiUrl = 'https://api.github.com/repos/obs-ndi/obs-ndi/releases/latest'

function global:au_BeforeUpdate {
  $Latest.Checksum32 = Get-RemoteChecksum -Url $Latest.Url32 -Algorithm 'SHA256'
}

function global:au_SearchReplace {
  @{
    ".\tools\chocolateyInstall.ps1" = @{
      "(?i)(^[$]url\s*=\s*)'.*'"        = "`${1}'$($Latest.URL32)'"
      "(?i)(^[$]checksum\s*=\s*)'.*'"   = "`${1}'$($Latest.Checksum32)'"
    }
  }
}

function global:au_GetLatest {
  $response = Invoke-WebRequest -Uri $obsNdiUrl -UseBasicParsing
  $json = ConvertFrom-Json $response
  $windowsAsset = ($json.assets | Where-Object { $_.name -Match ".*\.exe" } | Select-Object -First 1)

  return @{
    Version = $json.tag_name
    URL32   = $windowsAsset.browser_download_url
  }
}

# run the update only if this script is not sourced by the virtual package
if ($MyInvocation.InvocationName -ne '.') {
  [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12
  Update-Package -NoCheckUrl -NoCheckChocoVersion -NoReadme -ChecksumFor none -Force:$Force
}