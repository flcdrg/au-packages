import-module au

function global:au_SearchReplace {
    @{
    }
}

. ../_scripts/GitHub.ps1

function global:au_BeforeUpdate() {

    Get-RemoteFiles -Purge

    # Just include .exe in package rather than zip which we would then need to unzip
    Push-Location tools
    Get-ChildItem *.exe | Remove-Item -Force
    Expand-Archive $global:Latest.FileName32 -DestinationPath .
    Remove-Item $global:Latest.FileName32 -Force
    Pop-Location
}

function global:au_GetLatest {
    $release = Get-GitHubLatestRelease "stripe/stripe-cli"
    
    $version = Get-ReleaseVersion $release "v"

    if (-not $version) {
        return @{}
    }

    $assets = Get-GitHubReleaseAssets $release

    $asset = $assets | Where-Object { $_.name.EndsWith("windows_x86_64.zip") } | Select-Object -First 1
    # stripe_1.5.8_windows_x86_64.zip
    # https://github.com/stripe/stripe-cli/releases/download/v1.5.8/stripe_1.5.8_windows_x86_64.zip

    $Latest = @{
        URL32 = $asset.browser_download_url
        Version = $version
    }
    return $Latest
}

update -ChecksumFor none