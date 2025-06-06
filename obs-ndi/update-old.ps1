Import-Module chocolatey-au

$ErrorActionPreference = 'Stop'

$obsNdiUrl = 'https://api.github.com/repos/DistroAV/DistroAV/releases/latest'

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

update