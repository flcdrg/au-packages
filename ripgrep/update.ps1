#Import-Module chocolatey-au
Import-Module "$PSScriptRoot\..\..\chocolatey-au\src\chocolatey-au.psd1"

function global:au_SearchReplace {
    @{
        ".\tools\chocolateyInstall.ps1" = @{
            "(?i)(^\s*FileFullPath\s*=\s*)(.*)" = "`$1Join-Path `$toolsDir '$($Latest.FileName32)'"
            "(?i)(^\s*FileFullPath64\s*=\s*)(.*)" = "`$1Join-Path `$toolsDir '$($Latest.FileName64)'"
        }
        "ripgrep.nuspec" = @{
            "\d+\.\d+\.\d+" = "$($Latest.Version)"
        }
    }
}

. ../_scripts/GitHub.ps1

function global:au_GetLatest {
    $release = Get-GitHubLatestRelease 'BurntSushi/ripgrep'

    $version = Get-ReleaseVersion -release $release

    if (-not $version) {
        Write-Warning "Couldn't find version number"
        return 'Ignore'
    }

    $assetUrls = @{}
    foreach ($asset in $release.assets) {
        if ($asset.name -like 'ripgrep-*i686-pc-windows-msvc.zip') {
            $assetUrls['32'] = $asset.browser_download_url
        }
        elseif ($asset.name -like 'ripgrep-*x86_64-pc-windows-msvc.zip') {
            $assetUrls['64'] = $asset.browser_download_url
        }
    }

    if (-not $assetUrls['32'] -or -not $assetUrls['64']) {
        Write-Warning "Couldn't find expected release assets"
        return 'Ignore'
    }

    @{
        URL32 = $assetUrls['32']
        URL64 = $assetUrls['64']
        Version = $version
    }
}

Update-Package -ChecksumFor None
