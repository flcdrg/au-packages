# Get-ChocolateyUnzip isn't imported by AU for this package
Import-Module $env:ChocolateyInstall\helpers\chocolateyInstaller.psm1

Import-Module chocolatey-au

function global:au_SearchReplace {
    @{ }
}

. ../_scripts/GitHub.ps1

. ../_scripts/Submit-VirusTotal.ps1

function global:au_BeforeUpdate() {
    Get-RemoteFiles -Purge -NoSuffix

    $toolsPath = "tools"
    
    $packageArgs = @{
        FileFullPath64 = Get-Item $toolsPath\*-windows-amd64.tar.gz
        Destination    = $toolsPath
    }

    Get-ChocolateyUnzip @packageArgs
      
    if (Test-Path "$toolsPath\kubeseal*.tar") {
        $packageArgs2 = @{
            FileFullPath64 = Get-Item $toolsPath\*-windows-amd64.tar
            Destination    = $toolsPath
        }
        Get-ChocolateyUnzip @packageArgs2

        Remove-Item "$toolsPath\kubeseal*.tar*"

        if (Test-Path "$toolsPath\LICENSE") {
            Move-Item -Force "$toolsPath\LICENSE" "$toolsPath\LICENSE.txt"
        }

        if (Test-Path "$toolsPath\README.md") {
            Remove-Item "$toolsPath\README.md"
        }
    }
}

function global:au_GetLatest {
    # https://github.com/bitnami-labs/sealed-secrets/releases/download/v0.25.0/kubeseal-0.25.0-windows-amd64.tar.gz
    $release = Get-GitHubLatestRelease "bitnami-labs/sealed-secrets"

    $version = Get-ReleaseVersion -release $release -prefix "v"

    # Convert semver2 to semver1
    $version = $version.Replace("-beta.", "-beta").Replace("-rc.", "-rc")

    if (-not $version) {
        Write-Warning "Couldn't find version number"
        return "Ignore"
    }

    $assets = Invoke-RestMethod -Method Get -Uri $release.assets_url -Headers $headers

    $asset64 = $assets | Where-Object { $_.name.EndsWith("windows-amd64.tar.gz") }

    $Latest = @{
        Version      = $version
        Url64        = $asset64.browser_download_url
        ReleaseNotes = $release.body.Replace("# ", "## ") # Increase heading levels
    }
    return $Latest
}

function global:au_AfterUpdate ($Package) {
    Update-ReleaseNotes $Package

    Send-FileToVirusTotal tools/kubeseal.exe
}

update -ChecksumFor 64
