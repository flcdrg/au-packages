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

    $releasesUrl = "https://api.github.com/repos/Microsoft/azure-pipelines-agent/releases"
    $response = Invoke-RestMethod -Method Get -Uri $releasesUrl -Headers $headers

    $Latest = @{
        Streams = [ordered] @{
        }
    }

    # Assume releases are named v1.2.3
    foreach ($prefix in "v2", "v3") {
        $release = $response | Where-Object { $_.name.StartsWith($prefix) -and -not $_.prerelease } | Select-Object -First 1

        $version = $release.name.Substring(1)

        $assets = Invoke-RestMethod -Method Get -Uri $release.assets_url -Headers $headers

        $assetsJson = Invoke-RestMethod -Method Get -Uri $assets[0].browser_download_url -Headers $headers

        # Note at some point we may want to offer the non-node installers as well, which use 'pipeline-agent' as a prefix
        # See https://github.com/microsoft/azure-pipelines-agent/pull/3170 for more context
        $asset32 = $assetsJson | Where-Object { $_.platform -eq "win-x86" -and $_.name.StartsWith("vsts-agent") }
        $asset64 = $assetsJson | Where-Object { $_.platform -eq "win-x64" -and $_.name.StartsWith("vsts-agent") }

        $Latest.Streams.Add($prefix, @{
            Url32 = $asset32.downloadUrl
            Url64 = $asset64.downloadUrl
            Version = $version
        })
    }

    return $Latest
}

update -NoReadme