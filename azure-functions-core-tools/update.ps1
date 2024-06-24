Import-Module chocolatey-au

. ../_scripts/GitHub.ps1

function global:au_SearchReplace {
    @{}
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