Import-Module chocolatey-au

function global:au_SearchReplace {
    @{
        'tools\chocolateyInstall.ps1' = @{
            "(^\`$url\s*=\s*)('.*')"    = "`$1'$($Latest.Url32)'"
            "(^\`$url64\s*=\s*)('.*')"   = "`$1'$($Latest.Url64)'"
            "(^\`$checksum\s*=\s*)('.*')"   = "`$1'$($Latest.Checksum32)'"
            "(^\`$checksum64\s*=\s*)('.*')"   = "`$1'$($Latest.Checksum64)'"
        }
    }
}

. ../_scripts/GitHub.ps1

function global:au_GetLatest {
    $release = Get-GitHubLatestRelease "exeldro/obs-move-transition"
    
    $version = Get-ReleaseVersion $release "Version " $release.name.Substring(1)

    if (-not $version) {
        return @{}
    }

    # TODO - this package doens't publish downloads in GitHub!
    $assets = Get-GitHubReleaseAssets $release

    $assetsJson = Get-GitHubReleaseAssetsBrowserDownloadUrls $assets

    # Note at some point we may want to offer the non-node installers as well, which use 'pipeline-agent' as a prefix
    # See https://github.com/microsoft/azure-pipelines-agent/pull/3170 for more context
    $asset32 = $assetsJson | Where-Object { $_.platform -eq "win-x86" -and $_.name.StartsWith("vsts-agent") }
    $asset64 = $assetsJson | Where-Object { $_.platform -eq "win-x64" -and $_.name.StartsWith("vsts-agent") }
    $Latest = @{
        Url32 = $asset32.downloadUrl
        Url64 = $asset64.downloadUrl
        Version = $version
    }
    return $Latest
}

update