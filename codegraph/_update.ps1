Import-Module chocolatey-au
. ../_scripts/GitHub.ps1

function global:au_GetLatest {
    try {
        $release = Find-GitHubRelease 'colbymchenry/codegraph' {
            -not $_.draft -and -not $_.prerelease -and $_.tag_name -match '^v\d+\.\d+\.\d+$'
        }
    } catch {
        Write-Warning "Couldn't query CodeGraph releases: $($_.Exception.Message)"
        return 'Ignore'
    }

    if (-not $release) {
        Write-Warning "Couldn't find a stable CodeGraph release"
        return 'Ignore'
    }

    $version = $release.tag_name -replace '^v', ''
    try {
        $assets = Get-GitHubReleaseAssets $release
    } catch {
        Write-Warning "Couldn't query CodeGraph release assets: $($_.Exception.Message)"
        return 'Ignore'
    }

    $x64Asset = $assets | Where-Object { $_.name -eq 'codegraph-win32-x64.zip' }
    $arm64Asset = $assets | Where-Object { $_.name -eq 'codegraph-win32-arm64.zip' }
    $manifestAsset = $assets | Where-Object { $_.name -eq 'SHA256SUMS' }

    if (-not $x64Asset -or -not $arm64Asset -or -not $manifestAsset) {
        Write-Warning "CodeGraph $version is missing a required Windows asset or SHA256SUMS"
        return 'Ignore'
    }

    try {
        $manifest = Invoke-RestMethod -Uri $manifestAsset.browser_download_url
        if ($manifest -is [byte[]]) {
            $manifest = [System.Text.Encoding]::UTF8.GetString($manifest)
        }
    } catch {
        Write-Warning "Couldn't download the CodeGraph $version checksum manifest: $($_.Exception.Message)"
        return 'Ignore'
    }

    $x64Hash = [regex]::Match($manifest, '(?m)^([a-fA-F0-9]{64})\s+codegraph-win32-x64\.zip\s*$')
    $arm64Hash = [regex]::Match($manifest, '(?m)^([a-fA-F0-9]{64})\s+codegraph-win32-arm64\.zip\s*$')
    if (-not $x64Hash.Success -or -not $arm64Hash.Success) {
        Write-Warning "CodeGraph $version SHA256SUMS is missing a required Windows checksum"
        return 'Ignore'
    }

    @{
        Version      = $version
        UrlX64       = $x64Asset.browser_download_url
        ChecksumX64  = $x64Hash.Groups[1].Value.ToLowerInvariant()
        UrlArm64     = $arm64Asset.browser_download_url
        ChecksumArm64 = $arm64Hash.Groups[1].Value.ToLowerInvariant()
        ReleaseNotes = "https://github.com/colbymchenry/codegraph/releases/tag/$($release.tag_name)"
    }
}

function global:au_SearchReplace {
    @{
        'tools\chocolateyinstall.ps1' = @{
            "(^\s*\`$urlX64\s*=\s*)('.*')"        = "`$1'$($Latest.UrlX64)'"
            "(^\s*\`$urlArm64\s*=\s*)('.*')"      = "`$1'$($Latest.UrlArm64)'"
            "(^\s*\`$checksumX64\s*=\s*)('.*')"   = "`$1'$($Latest.ChecksumX64)'"
            "(^\s*\`$checksumArm64\s*=\s*)('.*')" = "`$1'$($Latest.ChecksumArm64)'"
        }
    }
}

function global:au_AfterUpdate ($Package) {
    Update-ReleaseNotes $Package
}

update -ChecksumFor none
