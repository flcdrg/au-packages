import-module au

function global:au_SearchReplace {
    @{
        'tools\chocolateyInstall.ps1' = @{
            "(^\s*checksum\s*=\s*)('.*')"   = "`$1'$($Latest.Checksum32)'"
            "(^\s*checksum64\s*=\s*)('.*')"   = "`$1'$($Latest.Checksum64)'"
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

    $Latest = @{
        Version = $version
        ReleaseNotes = $release.body.Replace("# ", "## ") # Increase heading levels
    }
    return $Latest
}

function global:au_AfterUpdate ($Package) {
    Update-ReleaseNotes $Package
}

update -NoCheckUrl -NoCheckChocoVersion