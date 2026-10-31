Import-Module chocolatey-au

function global:au_SearchReplace {
    @{
        'tools\chocolateyinstall.ps1' = @{
            "(?im)(^\s*\`$releaseTag\s*=\s*)('.*')"     = "`$1'$($Latest.ReleaseTag)'"
            "(?im)(^\s*\`$checksum64\s*=\s*)('.*')"     = "`$1'$($Latest.Checksum64)'"
            "(?im)(^\s*\`$checksumArm64\s*=\s*)('.*')" = "`$1'$($Latest.ChecksumArm64)'"
        }
        'waza.nuspec' = @{
            "(?i)(<releaseNotes>).*?(</releaseNotes>)" = "`$1$($Latest.ReleaseNotes)`$2"
        }
    }
}

. ../_scripts/GitHub.ps1

function global:au_GetLatest {
    # The repository also publishes 'azd-ext-microsoft-azd-waza_*' releases (and GitHub marks those as
    # 'latest') and may have pre-release 'vX.Y.Z-rc' tags ahead of the newest stable CLI release, so scan
    # the release list for the first stable 'vX.Y.Z' tag rather than trusting the first 'v' match.
    $release = Find-GitHubRelease 'microsoft/waza' { -not $_.prerelease -and -not $_.draft -and $_.tag_name -match '^v\d+\.\d+\.\d+$' }

    if (-not $release) {
        Write-Warning "Couldn't find a stable standalone Waza release"
        return 'Ignore'
    }

    $version = Get-ReleaseVersion -release $release -prefix 'v'

    # The install script builds download URLs from the tag and these file names, so the binaries must
    # actually be uploaded to the release, not merely listed in the manifest.
    $assets = @(Get-GitHubReleaseAssets $release | ForEach-Object { $_ })
    $requiredAssets = 'waza-windows-amd64.exe', 'waza-windows-arm64.exe', 'checksums.txt'
    $missingAssets = $requiredAssets | Where-Object { $_ -notin $assets.name }
    if ($missingAssets) {
        Write-Warning "Release $($release.tag_name) is missing expected asset(s): $($missingAssets -join ', ')"
        return 'Ignore'
    }

    $checksumAsset = $assets | Where-Object { $_.name -eq 'checksums.txt' } | Select-Object -First 1
    try {
        $checksumContent = Invoke-RestMethod -Uri $checksumAsset.browser_download_url
    }
    catch {
        Write-Warning "Couldn't download checksums.txt for release $($release.tag_name): $($_.Exception.Message)"
        return 'Ignore'
    }

    $checksum64 = [regex]::Match($checksumContent, '(?m)^([a-fA-F0-9]{64})\s+waza-windows-amd64\.exe\s*$')
    $checksumArm64 = [regex]::Match($checksumContent, '(?m)^([a-fA-F0-9]{64})\s+waza-windows-arm64\.exe\s*$')

    if (-not $checksum64.Success -or -not $checksumArm64.Success) {
        Write-Warning "Couldn't find both Windows checksums in checksums.txt for release $($release.tag_name)"
        return 'Ignore'
    }

    @{
        Version       = $version
        ReleaseTag    = $release.tag_name
        Checksum64    = $checksum64.Groups[1].Value.ToLowerInvariant()
        ChecksumArm64 = $checksumArm64.Groups[1].Value.ToLowerInvariant()
        ReleaseNotes  = "https://github.com/microsoft/waza/releases/tag/$($release.tag_name)"
    }
}

update -ChecksumFor none