Import-Module chocolatey-au
. ../_scripts/GitHub.ps1

function global:au_GetLatest {
    $assetName = 'apm-windows-x86_64.zip'
    $checksumAssetName = "$assetName.sha256"

    $release = Find-GitHubRelease 'microsoft/apm' {
        -not $_.prerelease -and $_.tag_name -match '^v\d+\.\d+\.\d+$'
    }
    if (-not $release) {
        Write-Warning 'Could not find a stable APM release with a three-part version tag.'
        return 'Ignore'
    }

    $version = Get-ReleaseVersion -release $release -prefix 'v'
    if (-not $version -or $version -notmatch '^\d+\.\d+\.\d+$') {
        Write-Warning "Could not parse a stable APM version from release tag '$($release.tag_name)'."
        return 'Ignore'
    }

    $assets = @(Get-GitHubReleaseAssets $release | ForEach-Object { $_ })
    $archive = $assets | Where-Object { $_.name -eq $assetName } | Select-Object -First 1
    $checksumAsset = $assets | Where-Object { $_.name -eq $checksumAssetName } | Select-Object -First 1
    if (-not $archive -or -not $checksumAsset) {
        Write-Warning "Release $($release.tag_name) is missing $assetName or $checksumAssetName."
        return 'Ignore'
    }

    try {
        $checksumResponse = Invoke-WebRequest -Uri $checksumAsset.browser_download_url -UseBasicParsing -TimeoutSec 30
        $checksumText = if ($checksumResponse.Content -is [byte[]]) {
            [Text.Encoding]::UTF8.GetString($checksumResponse.Content)
        } else {
            [string]$checksumResponse.Content
        }
    } catch {
        Write-Warning "Could not download the APM Windows checksum asset: $_"
        return 'Ignore'
    }

    $checksumMatch = [regex]::Match(
        [string]$checksumText,
        "(?im)^\s*([a-f0-9]{64})\s+\*?$([regex]::Escape($assetName))\s*$"
    )
    if (-not $checksumMatch.Success) {
        Write-Warning "The APM Windows checksum asset did not contain a valid entry for $assetName."
        return 'Ignore'
    }

    $checksum = $checksumMatch.Groups[1].Value.ToLowerInvariant()
    if ($archive.digest -and $archive.digest -ne "sha256:$checksum") {
        Write-Warning "The APM Windows checksum sidecar does not match the GitHub release digest for $assetName."
        return 'Ignore'
    }

    @{
        Version      = $version
        Url32        = $archive.browser_download_url
        Checksum32   = $checksum
        FileName32   = $assetName
        ReleaseNotes = if ($release.body) {
            $release.body
        } else {
            "https://github.com/microsoft/apm/releases/tag/$($release.tag_name)"
        }
    }
}

function global:au_BeforeUpdate {
    Get-RemoteFiles -Purge -NoSuffix
}

function global:au_SearchReplace {
    @{
        'tools\VERIFICATION.txt' = @{
            '(?m)^Download URL: https://github\.com/microsoft/apm/releases/download/[^/]+/apm-windows-x86_64\.zip$' = "Download URL: $($Latest.Url32)"
            '(?m)^SHA256: [a-fA-F0-9]{64}$' = "SHA256: $($Latest.Checksum32)"
        }
    }
}

function global:au_AfterUpdate ($Package) {
    Update-ReleaseNotes $Package
}

update -ChecksumFor none
