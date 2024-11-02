Import-Module chocolatey-au

$ErrorActionPreference = 'Stop'

function global:au_SearchReplace {
  @{
    ".\tools\chocolateyInstall.ps1" = @{
      "(?i)(^[$]url64\s*=\s*)'.*'"        = "`${1}'$($Latest.URL64)'"
      "(?i)(^[$]checksum64\s*=\s*)'.*'"   = "`${1}'$($Latest.Checksum64)'"
    }
  }
}

. ../_scripts/GitHub.ps1

function global:au_GetLatest {
  $release = Get-GitHubLatestRelease "pbi-tools/pbi-tools"
    
  $version = Get-ReleaseVersion -release $release

  # Convert semver2 to semver1
  $version = $version.Replace("-beta.", "-beta").Replace("-rc.", "-rc")

  if (-not $version) {
      Write-Warning "Couldn't find version number"
      return "Ignore"
  }

  $assets = Invoke-RestMethod -Method Get -Uri $release.assets_url -Headers $headers

  # filename 'pbi-tools.1.1.1.zip'
  $asset64 = $assets | Where-Object { $_.name -match 'pbi-tools\.\d+\.\d+\.\d+\.zip' } | Select-Object -First 1

  $Latest = @{
      Version      = $version
      Url64        = $asset64.browser_download_url
      ReleaseNotes = $release.body.Replace("# ", "## ") # Increase heading levels
  }
  return $Latest
}

function global:au_AfterUpdate ($Package) {
  Update-ReleaseNotes $Package
}

update -ChecksumFor 64