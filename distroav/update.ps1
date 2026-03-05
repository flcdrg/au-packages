Import-Module chocolatey-au
#Import-Module "$PSScriptRoot\..\..\chocolatey-au\src\chocolatey-au.psm1"

$ErrorActionPreference = 'Stop'

function global:au_SearchReplace {
  @{
    ".\tools\chocolateyInstall.ps1" = @{
      "(?i)(^[$]url\s*=\s*)'.*'"        = "`${1}'$($Latest.URL32)'"
      "(?i)(^[$]checksum\s*=\s*)'.*'"   = "`${1}'$($Latest.Checksum32)'"
    }
  }
}

. ..\_scripts\GitHub.ps1

function global:au_GetLatest {

  # Avoid prereleases that may not include Windows assets.
  $release = Get-GitHubLatestRelease -project 'DistroAV/DistroAV'

  $windowsAsset = $release.assets |
    Where-Object { $_.name -match 'windows.*installer\.exe$' } |
    Select-Object -First 1

  if (-not $windowsAsset) {
    throw "No Windows installer asset found in release '$($release.tag_name)'"
  }

  if (-not $windowsAsset.digest -or $windowsAsset.digest -notmatch ':') {
    throw "No digest returned for asset '$($windowsAsset.name)'"
  }

  ($checksumType, $checksumValue) = ($windowsAsset.digest -split ':')[0..1]
  return @{
    Version = $release.tag_name
    URL32   = $windowsAsset.browser_download_url
    ReleaseNotes = $release.html_url
    Checksum32 = $checksumValue
    Checksum32Type = $checksumType
  }
}

function global:au_AfterUpdate ($Package) {
    Update-ReleaseNotes $Package
}

update -ChecksumFor none