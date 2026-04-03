Import-Module chocolatey-au

$ErrorActionPreference = 'Stop'

function global:au_SearchReplace {
  @{
    '.\tools\chocolateyInstall.ps1' = @{
      "(?i)(^[$]url\s*=\s*)'.*'" = "`${1}'$($Latest.URL32)'"
      "(?i)(^[$]checksum\s*=\s*)'.*'" = "`${1}'$($Latest.Checksum32)'"
    }
  }
}

function Get-NormalizedVersion {
  param(
    [Parameter(Mandatory = $true)]
    [string]$Version
  )

  $trimmedVersion = $Version.Trim()

  try {
    $parsedVersion = [version]$trimmedVersion
  } catch {
    return $trimmedVersion
  }

  if ($parsedVersion.Revision -eq 0) {
    return $parsedVersion.ToString(3)
  }

  return $parsedVersion.ToString()
}

function global:au_GetLatest {
  $url = 'https://downloads.ndi.tv/Tools/NDI%206%20Tools.exe'
  $installerPath = Join-Path $env:TEMP 'NDI-Tools-Setup.exe'

  $currentProgressPreference = $ProgressPreference
  $ProgressPreference = 'SilentlyContinue'
  Invoke-WebRequest -Uri $url -OutFile $installerPath
  $ProgressPreference = $currentProgressPreference

  try {
    $fileVersion = [System.Diagnostics.FileVersionInfo]::GetVersionInfo($installerPath).ProductVersion
    $checksum = (Get-FileHash $installerPath -Algorithm SHA256).Hash

    return @{
      Version = Get-NormalizedVersion -Version $fileVersion
      URL32 = $url
      Checksum32 = $checksum
      ReleaseNotes = 'https://docs.ndi.video/all/using-ndi/ndi-tools/release-notes'
    }
  }
  finally {
    Remove-Item $installerPath -Force -ErrorAction SilentlyContinue
  }
}

update -ChecksumFor none