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
    $release = Get-GitHubLatestRelease "VirusTotal/vt-cli"
    
    $version = Get-ReleaseVersion -release $release

    if (-not $version) {
        Write-Warning "Couldn't find version number"
        return "Ignore"
    }

    # TODO - this package doens't publish downloads in GitHub!
    $assets = Get-GitHubReleaseAssets $release

    $asset32 = $assets | Where-Object { $_.name -eq "Windows32.zip" }
    $asset64 = $assets | Where-Object { $_.name -eq "Windows64.zip" }
    $Latest = @{
        Url32 = $asset32.browser_download_url
        Url64 = $asset64.browser_download_url
        Version = $version
    }
    return $Latest
}

update