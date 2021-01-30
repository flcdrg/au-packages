
# global
$headers = @{}

<#
.SYNOPSIS
    Get the info for the latest release

.PARAMETER project
    GitHub project path (used to create URL for API)

.OUTPUTS
    Output (if any)

#>
function Get-GitHubLatestRelease($project) {

    $token = $env:github_api_key
    $script:headers = @{
        'User-Agent' = 'flcdrg'
    }
    if ($token) {
        $script:headers['Authorization'] = ("token {0}" -f $token)
    } else {
        Write-Warning "No auth token"
    }

    $releasesUrl = "https://api.github.com/repos/$project/releases"
    Invoke-RestMethod -Method Get -Uri "$releasesUrl/latest" -Headers $headers
}

function Get-GitHubReleaseAssets($release) {
    Invoke-RestMethod -Method Get -Uri $release.assets_url -Headers $script:headers
}

function Get-GitHubReleaseAssetsBrowserDownloadUrls($assets) {
    Invoke-RestMethod -Method Get -Uri $assets[0].browser_download_url -Headers $script:headers
}

function Get-ReleaseVersion($release, [string] $prefix) {
    if ($prefix) {
        if (-not $release.name.StartsWith($prefix)) {
            return $null
        }

        $release.name.Substring($prefix.Length)
    } else {
        $release.name
    }
}