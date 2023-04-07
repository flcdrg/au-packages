import-module au

function global:au_SearchReplace {
    @{ }
}

. ../_scripts/GitHub.ps1

function global:au_BeforeUpdate() {
    Get-RemoteFiles -Purge -NoSuffix
}

function global:au_GetLatest {
    # This repo has releases for the cli tool as well as VS Code vsix
    $release = Get-GitHubLatestRelease "hashicorp/consul"

    $version = Get-ReleaseVersion -release $release -prefix "v"

    # Convert semver2 to semver1
    $version = $version.Replace("-beta.", "-beta").Replace("-rc.", "-rc")

    if (-not $version) {
        Write-Warning "Couldn't find version number"
        return "Ignore"
    }

    $Latest = @{
        Version = $version
        Url32 = "https://releases.hashicorp.com/consul/$version/consul_$($version)_windows_386.zip"
        Url64 = "https://releases.hashicorp.com/consul/$version/consul_$($version)_windows_amd64.zip"
        ReleaseNotes = $release.body.Replace("# ", "## ") # Increase heading levels
    }
    return $Latest
}

function global:au_AfterUpdate ($Package) {
    Update-ReleaseNotes $Package
}

update