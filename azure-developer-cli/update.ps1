import-module au

function global:au_SearchReplace {
    @{
        'tools\chocolateyInstall.ps1' = @{
            "(^\`$url\s*=\s*)('.*')"    = "`$1'$($Latest.Url32)'"
            "(^\`$checksum\s*=\s*)('.*')"   = "`$1'$($Latest.Checksum32)'"
        }
    }
}

. ../_scripts/GitHub.ps1

function global:au_GetLatest {
    # This repo has releases for the cli tool as well as VS Code vsix
    $release = Get-GitHubLatestRelease "Azure/azure-dev" "azure-dev-cli"
    
    $version = Get-ReleaseVersion -release $release -prefix "azure-dev-cli_"

    # Convert semver2 to semver1
    $version = $version.Replace("-beta.", "-beta")

    if (-not $version) {
        Write-Warning "Couldn't find version number"
        return "Ignore"
    }

    $assets = Get-GitHubReleaseAssets $release

    $asset32 = $assets | Where-Object { $_.name -eq "azd-windows-amd64.zip" }

    $Latest = @{
        Url32 = $asset32.browser_download_url
        Version = $version
        ReleaseNotes = $release.body.Replace("# ", "## ") # Increase heading levels
    }
    return $Latest
}

function global:au_AfterUpdate ($Package) {
    # $cdata = $Package.NuspecXml.CreateCDataSection($Latest.ReleaseNotes)
    $Package.NuspecXml.package.metadata.releaseNotes."#cdata-section" = $Latest.ReleaseNotes
    $Package.SaveNuspec()
}

update