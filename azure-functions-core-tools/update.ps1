Import-Module chocolatey-au

. ../_scripts/GitHub.ps1

function global:au_SearchReplace {
    @{
        'tools\chocolateyInstall.ps1' = @{
            "(^\`$url_x86\s*=\s*)('.*')"      = "`$1'$($Latest.Url32)'"
            "(^\`$url_x64\s*=\s*)('.*')"      = "`$1'$($Latest.Url64)'"
            "(^\`$checksum_x86\s*=\s*)('.*')" = "`$1'$($Latest.Checksum32)'"
            "(^\`$checksum_x64\s*=\s*)('.*')" = "`$1'$($Latest.Checksum64)'"
        }
    }
}

function global:au_GetLatest {
    $release = Get-GitHubLatestRelease "Azure/azure-functions-core-tools" -newest

    $version = Get-ReleaseVersion -release $release

    # Convert semver2 to semver1
    $version = $version.Replace("-beta.", "-beta").Replace("-rc.", "-rc")

    if (-not $version) {
        Write-Warning "Couldn't find version number"
        return "Ignore"
    }

    $assets = Get-GitHubReleaseAssets $release
    $asset32 = $assets | Where-Object { $_.name -like "Azure.Functions.Cli.win-x86.*.zip" }
    $asset64 = $assets | Where-Object { $_.name -like "Azure.Functions.Cli.win-x64.*.zip" }

    $Latest = @{
        Version = $version
        Url32   = $asset32.browser_download_url
        Url64   = $asset64.browser_download_url
    }
    return $Latest
}

update -Force