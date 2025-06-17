# Import-Module chocolatey-au
Import-Module ..\..\chocolatey-au\src\Chocolatey-AU.psm1

function global:au_SearchReplace {
    @{
        'tools\chocolateyInstall.ps1' = @{
            "(^[$]fullUrl\s*=\s*)('.*')"         = "`$1'$($Latest.FullUrl)'"
            "(^[$]fullChecksum\s*=\s*)('.*')"    = "`$1'$($Latest.FullChecksum)'"
        }
     }
}

function Get-Download($url, $version)
{
    $request = Invoke-WebRequest -Method Head -Uri $url -MaximumRedirection 0 -SkipHttpErrorCheck -ErrorAction Ignore

    $r = @{}

    if($request.StatusCode -lt 400)
    {
        # $url        = 'http://download.microsoft.com/download/E/E/1/EE12CC0F-A1A5-4B55-9425-2AFBB2D63979/SSMS-Full-Setup.exe'

        $location = [UriBuilder] $request.Headers.Location[0]

        # Switch to https
        $location.Scheme = "https"
        $location.Port = 443

        $url = $location.Uri
        Write-Host "Downloading $url"

        $filename = [IO.Path]::GetFileName($url)
        $destPath = "$($env:TEMP)\chocolatey\sql-server-management-studio\$version"

        if (-not (Test-Path $destPath)) {
            New-Item -ItemType Directory $destPath | Out-Null
        }

        $filename = [IO.Path]::Combine($destPath, $filename)

        if (Test-Path $filename) {
            Write-Warning "$filename already exists, skipping download"
        } else {

            $currentProgressPreference = $ProgressPreference
            $ProgressPreference = 'silentlyContinue'        
            Invoke-WebRequest -Uri $url -OutFile $filename
            $ProgressPreference = $currentProgressPreference
        }

        $hash = Get-FileHash $filename -Algorithm SHA256
        $r = @{
            url = $url
            checksum = $hash.Hash
        }
    }
    return $r
}

function global:au_GetLatest {
    try {
        # Get latest version from XML
        $response = Invoke-RestMethod -Uri "https://aka.ms/ssms/21/release/channel"
        $version = $response.info.productDisplayVersion

        $releaseNotes = ($response.channelItems | Where-Object { $_.id -eq "Microsoft.VisualStudio.Product.Ssms" } | Select-Object -First 1).releaseNotes

        $download = Get-Download "https://aka.ms/ssms/21/release/vs_SSMS.exe" -version $version

        $Latest = @{
            PackageName = 'sql-server-management-studio'
            Version = $version
            ReleaseNotes = $releaseNotes
            FullChecksum = $download.checksum
            FullUrl = $download.url
        }

        return $Latest
    }
    catch {
        Write-Error $_
    }

    return 'ignore'
}

update -ChecksumFor none
