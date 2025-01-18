Import-Module chocolatey-au

function global:au_SearchReplace {
    @{
        'tools\chocolateyInstall.ps1' = @{
            "(^\s*url\s*=\s*)('.*')"    = "`$1'$($Latest.Url32)'"
            "(^\s*url64bit\s*=\s*)('.*')"    = "`$1'$($Latest.Url64)'"
            "(^\s*checksum\s*=\s*)('.*')"   = "`$1'$($Latest.Checksum32)'"
            "(^\s*checksum64\s*=\s*)('.*')"   = "`$1'$($Latest.Checksum64)'"
        }
    }
}

. ../_scripts/GitHub.ps1

function global:au_GetLatest {
    # This repo has releases for the cli tool as well as VS Code vsix
    $release = Get-GitHubLatestRelease "tenable/terrascan"
    
    $version = Get-ReleaseVersion -release $release -prefix "v"

    # Convert semver2 to semver1
    $version = $version.Replace("-beta.", "-beta")

    if (-not $version) {
        Write-Warning "Couldn't find version number"
        return "Ignore"
    }

    $assets = Get-GitHubReleaseAssets $release

    $asset32 = $assets | Where-Object { $_.name.EndsWith("Windows_i386.zip") }
    $asset64 = $assets | Where-Object { $_.name.EndsWith("Windows_x86_64.zip") }

    $Latest = @{
        Url32 = $asset32.browser_download_url
        Url64 = $asset64.browser_download_url
        Version = $version
        ReleaseNotes = $release.body.Replace("# ", "## ") # Increase heading levels
    }
    return $Latest
}

function global:au_AfterUpdate ($Package) {
    Update-ReleaseNotes $Package
}

update