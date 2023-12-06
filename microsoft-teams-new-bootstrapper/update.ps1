import-module au

function global:au_SearchReplace {
    @{
        'tools\chocolateyInstall.ps1' = @{
            "(^[$]checksum32\s*=\s*)('.*')"    = "`$1'$($Latest.Checksum32)'"
        }
     }
}

function GetDownloadInfo($url) {
    Write-Verbose "Downloading $url"
    $client = new-object System.Net.WebClient
    $downloadedFile = [IO.Path]::GetTempFileName()

    $client.DownloadFile($url, $downloadedFile)

    $versionInfo = (Get-Item $downloadedFile).VersionInfo

    $version = $versionInfo.ProductVersion

    $checksum = (Get-FileHash $downloadedFile -Algorithm SHA256).Hash

    Remove-Item $downloadedFile -Force -ErrorAction Ignore

    @{
        Checksum = $checksum
        Version = $version
    }
}

function global:au_GetLatest {

    $Latest = @{}

    try {
        # Get latest versions
        $info32 = GetDownloadInfo "https://statics.teams.cdn.office.net/production-teamsprovision/lkg/teamsbootstrapper.exe"

        $Latest = @{
            Version = $info32.Version
            Checksum32 = $info32.Checksum
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