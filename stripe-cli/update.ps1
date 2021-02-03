import-module au

# function global:au_SearchReplace {
#     @{
#         'tools\chocolateyInstall.ps1' = @{
#             "(^\`$url\s*=\s*)('.*')"    = "`$1'$($Latest.Url32)'"
#             "(^\`$url64\s*=\s*)('.*')"   = "`$1'$($Latest.Url64)'"
#             "(^\`$checksum\s*=\s*)('.*')"   = "`$1'$($Latest.Checksum32)'"
#             "(^\`$checksum64\s*=\s*)('.*')"   = "`$1'$($Latest.Checksum64)'"
#         }
#     }
# }

. ../_scripts/GitHub.ps1

function global:au_BeforeUpdate() {
    #Download $Latest.URL32 / $Latest.URL64 in tools directory and remove any older installers.
    Get-RemoteFiles -Purge
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

    

    # Note at some point we may want to offer the non-node installers as well, which use 'pipeline-agent' as a prefix
    # See https://github.com/microsoft/azure-pipelines-agent/pull/3170 for more context

    $Latest = @{
        URL32 = $asset.browser_download_url
        Version = $version
    }
    return $Latest
}

update -ChecksumFor none