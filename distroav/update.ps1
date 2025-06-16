Import-Module chocolatey-au

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

  $release = Get-GitHubLatestRelease -project 'DistroAV/DistroAV' -newest

  $windowsAsset = ($release.assets | Where-Object { $_.name -Match ".*\.exe" } | Select-Object -First 1)

  ($checksumType, $checksumValue) = ($windowsAsset.digest -split ':')[0..1]
  return @{
    Version = $release.tag_name
    URL32   = $windowsAsset.browser_download_url
    ReleaseNotes = $release.html_url
    checksum = $checksumValue
    checksumType = $checksumType
  }
}

function global:au_AfterUpdate ($Package) {
    Update-ReleaseNotes $Package
}

update -ChecksumFor none