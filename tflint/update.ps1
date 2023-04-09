import-module au

function global:au_SearchReplace {
    @{
        'tools\chocolateyInstall.ps1' = @{
            "(^\s*checksum\s*=\s*)('.*')"   = "`$1'$($Latest.Checksum32)'"
            "(^\s*url\s*=\s*)('.*')"        = "`$1'$($Latest.Url32)'"
            "(^\s*checksum64\s*=\s*)('.*')" = "`$1'$($Latest.Checksum64)'"
            "(^\s*url64bit\s*=\s*)('.*')"   = "`$1'$($Latest.Url64)'"
        }
    }
}

. ../_scripts/GitHub.ps1

function global:au_GetLatest {
    $release = Get-GitHubLatestRelease "terraform-linters/tflint"

    $version = Get-ReleaseVersion -release $release -prefix "v"

    # Convert semver2 to semver1
    $version = $version.Replace("-beta.", "-beta").Replace("-rc.", "-rc")

    if (-not $version) {
        Write-Warning "Couldn't find version number"
        return "Ignore"
    }

    $assets = Get-GitHubReleaseAssets $release

    $asset32 = $assets | Where-Object { $_.name -eq "tflint_windows_386.zip" }
    $asset64 = $assets | Where-Object { $_.name -eq "tflint_windows_amd64.zip" }

    $Latest = @{
        Version = $version
        Url32 = $asset32.browser_download_url
        Url64 = $asset64.browser_download_url
        ReleaseNotes = $release.body.Replace("# ", "## ") # Increase heading levels
    }
    return $Latest
}

function global:au_AfterUpdate ($Package) {
    Update-ReleaseNotes $Package
}

update