
function GetJetbrainsReSharperPlatformLatestRelease($release) {
    $urls = @{
        "Release" = @{
            Version = "https://download.jetbrains.com/resharper/resharper-version.json"
            Updates = "https://download.jetbrains.com/resharper/resharper-updates.json"
            Hash = "https://download.jetbrains.com/resharper/dotUltimate.VERSIONMARKETINGSTRING/JetBrains.dotUltimate.VERSIONMARKETINGSTRING.zip.sha256"
            Url = "https://download.jetbrains.com/resharper/dotUltimate.VERSIONMARKETINGSTRING/JetBrains.dotUltimate.VERSIONMARKETINGSTRING.zip"
        }
        "Release-EAP" = @{
            Version = "https://download.jetbrains.com/resharper/resharper-version-eap.json"
            Updates = "https://download.jetbrains.com/resharper/resharper-updates-eap.json"

            Hash = "https://download.jetbrains.com/resharper/dotUltimate.VERSIONMARKETINGSTRING/JetBrains.dotUltimate.VERSIONMARKETINGSTRING.Checked.zip.sha256"
            Url = "https://download.jetbrains.com/resharper/dotUltimate.VERSIONMARKETINGSTRING/JetBrains.dotUltimate.VERSIONMARKETINGSTRING.Checked.zip"
        }
    }

    # Prefer version from here, rather than from PackageMetadata.Version
    # 222.0.20220727.110528-eap11
    $version = (Invoke-RestMethod -Uri ($urls[$release].Version)) -replace "eap(\d)$", '-eap0$1' # "https://download.jetbrains.com/resharper/resharper-version.json"
    $updates = Invoke-RestMethod -Uri ($urls[$release].Updates) #"https://download-cf.jetbrains.com/resharper/resharper-updates.json"

    $package = $updates.AllPackages.InstallablePackage | Where-Object { $_.PackageMetadata.Id -eq "JetBrains.ReSharper.src" }
    $productInfo =  $package.ProductInfo | ConvertFrom-Json

    # "2022.2 EAP 11"
    $versionMarketingString = $productInfo.VersionMarketingString

    # "2022.2-EAP11", "2023.2 RC 1"
    $versionMarketingStringSemVer = ($versionMarketingString -replace " EAP ", "-EAP") -replace " RC ", "-RC" -replace "EAP(\d)$", 'EAP0$1' -replace "RC(\d)$", 'RC0$1'

    # "2022.2.EAP11"
    $versionMarketingStringDotted = $versionMarketingString -replace " EAP ", ".EAP" -replace " RC ", ".RC"

    $url = $urls[$release].Hash -replace "VERSIONMARKETINGSTRING", $versionMarketingStringDotted
    try {
        $data = Invoke-RestMethod -Uri $url
    }
    catch {
        if ($release -eq 'Release-EAP' -and [int]$_.Exception.Response.StatusCode -eq 404) {
            Write-Warning "Skipping $release because its installer is not available: $url"
            return $null
        }

        throw
    }
    ($hashcode, $filename) = $data.Trim() -split "\s\*" #.Split(([string[]] ," *"), [System.StringSplitOptions]::RemoveEmptyEntries)

    $url = $urls[$release].Url -replace "VERSIONMARKETINGSTRING", $versionMarketingStringDotted

    $Latest = @{
        # Dependent packages run the installer extracted from the offline ZIP.
        Filename = [System.IO.Path]::ChangeExtension($filename.Trim(), '.exe')
        Checksum32 = $hashcode
        Version = $version

        # Used in title
        MarketingVersion = $versionMarketingStringSemVer

        # Used in URL
        VersionMarketingStringDotted = $versionMarketingStringDotted
        Url32 = $url
    }
    return $Latest
}

function GetJetbrainsReSharperPlatformLatest {
    $release = GetJetbrainsReSharperPlatformLatestRelease "Release"
    $releaseEap = GetJetbrainsReSharperPlatformLatestRelease "Release-EAP"

    $Latest = @{
        Streams = [ordered] @{
            "Release" = $release
        }
    }

    if ($releaseEap) {
        $Latest.Streams['Release-Eap'] = $releaseEap
    }

    return $Latest
}

function GetJetbrainsProductLatest {
    $latest = GetJetbrainsReSharperPlatformLatest

    $streams = $latest.Streams
    foreach ($key in $streams.Keys) {
        $streams[$key].PlatformVersion = $streams[$key].Version
        $streams[$key].Version = $streams[$key].MarketingVersion
    }

    return $latest
}
