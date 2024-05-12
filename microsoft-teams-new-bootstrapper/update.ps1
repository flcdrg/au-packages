Import-Module chocolatey-au

function global:au_SearchReplace {
    @{
        'tools\chocolateyInstall.ps1'             = @{
            "(^[$]bootstrapperChecksum32\s*=\s*)('.*')" = "`$1'$($Latest.Checksum32)'"
            "(^[$]msix64url\s*=\s*)('.*')"              = "`$1'$($Latest.Msix64)'"
            "(^[$]msix64checksum\s*=\s*)('.*')"         = "`$1'$($Latest.Msix64Checksum)'"
            "(^[$]msix86url\s*=\s*)('.*')"              = "`$1'$($Latest.Msix86)'"
            "(^[$]msix86checksum\s*=\s*)('.*')"         = "`$1'$($Latest.Msix86Checksum)'"
        }
        'microsoft-teams-new-bootstrapper.nuspec' = @{
            # Regex to match 'Bootstrapper version: 1.0.2402201' and replace version number
            "(^Bootstrapper version:)(.*)"                   = "`$1 $($Latest.BootstrapperVersion)"
            # Regex to match 'Teams MSIX client (MSIX) version: 24004.1307.2669.7070' and replace version number
            "(^Teams MSIX client `\`(MSIX`\`) version:)(.*)" = "`$1 $($Latest.MsixVersion)"
        }
    }
}

function GetDownloadInfo($url, [switch]$NoVersion) {

    # return @{
    #     Checksum = "none"
    #     Version  = "1.2.3.4"
    # }

    Write-Verbose "Downloading $url"
    $client = new-object System.Net.WebClient
    $downloadedFile = [IO.Path]::GetTempFileName()

    $client.DownloadFile($url, $downloadedFile)

    if (-not $NoVersion.IsPresent) {
        $versionInfo = (Get-Item $downloadedFile).VersionInfo

        $version = $versionInfo.ProductVersion
    }
    else {
        $version = ""
    }

    $checksum = (Get-FileHash $downloadedFile -Algorithm SHA256).Hash

    Remove-Item $downloadedFile -Force -ErrorAction Ignore

    @{
        Checksum = $checksum
        Version  = $version
    }
}

function global:au_GetLatest {

    $Latest = @{}

    try {
        # Get latest versions
        $info32 = GetDownloadInfo "https://statics.teams.cdn.office.net/production-teamsprovision/lkg/teamsbootstrapper.exe"

        $bootstrapperVersion = [Version] $info32.Version

        $json = Invoke-RestMethod "https://config.teams.microsoft.com/config/v1/MicrosoftTeams/49_1.0.0.0?environment=prod&audienceGroup=general&teamsRing=general&agent=TeamsBuilds"

        # WebView2Canary is Teams 2.1 (Enterprise)
        $x64 = $json.BuildSettings.WebView2Canary.x64
        $x86 = $json.BuildSettings.WebView2Canary.x86

        $msixVersion = [version]($x64.latestVersion)

        $msixX64Url = $x64.buildLink
        $msixX86Url = $x86.buildLink
        $msixX64Info = GetDownloadInfo $msixX64Url -NoVersion
        $msixX86Info = GetDownloadInfo $msixX86Url -NoVersion

        $combinedVersion = [version]::new( $bootstrapperVersion.Major, $bootstrapperVersion.Minor, $bootstrapperVersion.Build, $msixVersion.Major )
        
        $Latest = @{
            Version             = $combinedVersion.ToString() + "-pre" # Remove -pre when the package is released
            Checksum32          = $info32.Checksum
            Msix64              = $x64.buildLink
            Msix64Checksum      = $msixX64Info.Checksum
            Msix86              = $x86.buildLink
            Msix86Checksum      = $msixX86Info.Checksum
            MsixVersion         = $msixVersion
            BootstrapperVersion = $bootstrapperVersion.ToString()
        }
    }
    catch {
        if ($_.Exception.InnerException) {
            Write-Error $_.Exception.InnerException.Message
        }
        Write-Error $_
    }
    return $Latest
}

update -ChecksumFor none