Import-Module chocolatey-au

function global:au_SearchReplace {
    @{
        'mergiraf.nuspec' = @{
            "(?i)(<releaseNotes>).*?(</releaseNotes>)" = "`$1$($Latest.ReleaseNotes)`$2"
        }
    }
}

function global:au_BeforeUpdate() {
    Get-RemoteFiles -Purge -NoSuffix

    Push-Location tools
    Get-ChildItem mergiraf.exe -ErrorAction SilentlyContinue | Remove-Item -Force
    Expand-Archive -Path $global:Latest.FileName32 -DestinationPath . -Force
    Remove-Item $global:Latest.FileName32 -Force -ErrorAction SilentlyContinue
    Pop-Location
}

function global:au_GetLatest {
    $headers = @{
        'User-Agent' = 'flcdrg'
    }

    $releases = Invoke-RestMethod -Method Get -Uri 'https://codeberg.org/api/v1/repos/mergiraf/mergiraf/releases?limit=10' -Headers $headers
    $release = $releases | Where-Object { -not $_.draft -and -not $_.prerelease } | Select-Object -First 1

    if (-not $release) {
        Write-Warning "Couldn't find a non-prerelease release"
        return 'Ignore'
    }

    $version = if ($release.tag_name -and $release.tag_name.StartsWith('v')) {
        $release.tag_name.Substring(1)
    }
    elseif ($release.tag_name) {
        $release.tag_name
    }
    elseif ($release.name) {
        $release.name
    }

    # Convert semver2 to semver1
    $version = $version.Replace('-beta.', '-beta').Replace('-rc.', '-rc')

    if (-not $version) {
        Write-Warning "Couldn't find version number"
        return 'Ignore'
    }

    $asset = $release.assets | Where-Object { $_.name -match 'x86_64-pc-windows-gnu\.zip$' } | Select-Object -First 1
    if (-not $asset) {
        Write-Warning "Couldn't find Windows release asset"
        return 'Ignore'
    }

    return @{
        Version      = $version
        Url32        = $asset.browser_download_url
        ReleaseNotes = "https://codeberg.org/mergiraf/mergiraf/releases/tag/$($release.tag_name)"
    }
}

update -ChecksumFor none
