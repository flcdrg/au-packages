Import-Module chocolatey-au
. ../_scripts/common.ps1
. ../_scripts/Set-DescriptionFromReadme.ps1

function global:au_SearchReplace {
    @{
        'tools\chocolateyInstall.ps1' = @{
            '(?i)(^\s*\$urlX64\s*=\s*)(''.*'')' = "`$1'$($Latest.UrlX64)'"
            '(?i)(^\s*\$checksumX64\s*=\s*)(''.*'')' = "`$1'$($Latest.ChecksumX64)'"
            '(?i)(^\s*\$urlArm64\s*=\s*)(''.*'')' = "`$1'$($Latest.UrlArm64)'"
            '(?i)(^\s*\$checksumArm64\s*=\s*)(''.*'')' = "`$1'$($Latest.ChecksumArm64)'"
        }
    }
}

function global:au_GetLatest {
    $architectures = @(
        @{
            Name = 'X64'
            FileName = 'dotnetup-win-x64.exe'
        },
        @{
            Name = 'Arm64'
            FileName = 'dotnetup-win-arm64.exe'
        }
    )

    $latest = @{}

    foreach ($architecture in $architectures) {
        $binaryAlias = "https://aka.ms/dotnet/dotnetup/preview/$($architecture.FileName)"
        $checksumAlias = "$binaryAlias.sha512"

        try {
            $binaryUrl = Get-RedirectedUri -Uri $binaryAlias
            $checksumUrl = Get-RedirectedUri -Uri $checksumAlias

            if (-not $binaryUrl -or -not $checksumUrl) {
                throw "Could not resolve the preview URLs for $($architecture.Name)."
            }

            $versionMatch = [regex]::Match(
                $binaryUrl,
                '/public/dotnetup/(?<version>[^/]+)/' + [regex]::Escape($architecture.FileName) + '$'
            )
            $checksumVersionMatch = [regex]::Match(
                $checksumUrl,
                '/public-checksums/dotnetup/(?<version>[^/]+)/' + [regex]::Escape($architecture.FileName) + '\.sha512$'
            )

            if (-not $versionMatch.Success -or -not $checksumVersionMatch.Success) {
                throw "Could not determine the concrete preview version for $($architecture.Name)."
            }

            $upstreamVersion = $versionMatch.Groups['version'].Value
            if ($upstreamVersion -ne $checksumVersionMatch.Groups['version'].Value) {
                throw "The binary and checksum versions differ for $($architecture.Name)."
            }

            $response = Invoke-WebRequest -Uri $checksumUrl -UseBasicParsing
            $checksum = (($response.Content -split '\s+')[0]).Trim()
            if ($checksum -notmatch '^[a-fA-F0-9]{128}$') {
                throw "The SHA-512 checksum for $($architecture.Name) is missing or malformed."
            }

            $latest["Url$($architecture.Name)"] = $binaryUrl
            $latest["Checksum$($architecture.Name)"] = $checksum.ToUpperInvariant()
            $latest["Version$($architecture.Name)"] = $upstreamVersion
        }
        catch {
            Write-Warning "Unable to retrieve the dotnetup preview $($architecture.Name) release: $($_.Exception.Message)"
            return 'Ignore'
        }
    }

    if ($latest.VersionX64 -ne $latest.VersionArm64) {
        Write-Warning 'The dotnetup preview versions differ between x64 and Arm64.'
        return 'Ignore'
    }

    $versionMatch = [regex]::Match(
        $latest.VersionX64,
        '^(?<version>\d+\.\d+\.\d+)(?:-(?<prerelease>[0-9A-Za-z.-]+))?$'
    )
    if (-not $versionMatch.Success) {
        Write-Warning "The upstream version '$($latest.VersionX64)' is not a supported version string."
        return 'Ignore'
    }

    $version = $versionMatch.Groups['version'].Value
    if ($versionMatch.Groups['prerelease'].Success) {
        $prerelease = $versionMatch.Groups['prerelease'].Value -replace '\.', ''
        $version = "$version-$prerelease"
    }

    @{
        Version       = $version
        UrlX64        = $latest.UrlX64
        ChecksumX64   = $latest.ChecksumX64
        UrlArm64      = $latest.UrlArm64
        ChecksumArm64 = $latest.ChecksumArm64
    }
}

function global:au_AfterUpdate ($Package) {
    Set-DescriptionFromReadme -SkipFirst 2
}

update -ChecksumFor none
