import-module au

function global:au_SearchReplace {
    @{
        'tools\chocolateyInstall.ps1' = @{
            "(^\`$url\s*=\s*)('.*')"    = "`$1'$($Latest.Url32)'"
            "(^\`$checksum\s*=\s*)('.*')"   = "`$1'$($Latest.Checksum32)'"
        }
    }
}

function global:au_GetLatest {
    $token = $env:github_api_key
    $headers = @{
        'User-Agent' = 'flcdrg'
    }
    if ($token) {
        $headers['Authorization'] = ("token {0}" -f $token)
    } else {
        Write-Warning "No auth token"
    }

    $releasesUrl = "https://api.github.com/repos/dnephin/dobi/releases"
    $response = Invoke-RestMethod -Method Get -Uri "$releasesUrl/latest" -Headers $headers
    
    # Assume releases are named v1.2.3
    if (!$response.tag_name.StartsWith("v")) {
        return @{}
    }

    $version = $response.tag_name.Substring(1)

    $assets = Invoke-RestMethod -Method Get -Uri $response.assets_url -Headers $headers


    $asset32 = $assets | Where-Object { $_.name -eq "dobi-windows.exe" }

    $Latest = @{
        Url32 = $asset32.browser_download_url
        Version = $version
    }
    return $Latest
}

update