import-module au

. ..\_scripts\Submit-VirusTotal.ps1

function global:au_SearchReplace {
    @{
        'tools\chocolateyInstall.ps1' = @{
            "(^[$]url\s*=\s*)('.*')"      = "`$1'$($Latest.URL32)'"
            "(^[$]checksum\s*=\s*)('.*')" = "`$1'$($Latest.Checksum32)'"
        }
        "$($Latest.PackageName).nuspec" = @{
            "(\<releaseNotes\>).*?(\</releaseNotes\>)" = "`${1}$($Latest.ReleaseNotes)`$2"
        }
     }
}

function GetStream($download, [version] $minVersion)
{
    $nextVersion = New-Object version $minVersion.Major, ($minVersion.Minor+1), $minVersion.Build, $minVersion.Revision
    $download | Where-Object { [version] $_.version -ge $minVersion} |
        Where-Object { [version] $_.version -lt $nextVersion } | 
        Select-Object -Last 1 | 
        ForEach-Object {
        @{ 
            URL32 = $_.file_path
            Version = $_.version
            ReleaseNotes = $_.release_notes_url
        }
    }
}

function global:au_GetLatest {

    $response = Invoke-RestMethod -Uri "https://download.svc.ui.com/v1/software-downloads"

    $download = $response.downloads | Where-Object {
            $_.platform -eq "Windows" `
            -and $_.product_lines[0] -eq "unifi" `
            -and $_.category.slug -eq "software" `
            -and $_.filename.EndsWith(".exe") `
            -and -not ($_.version.StartsWith("v")) `
        } |
        Sort-Object { [version] $_.version };

    $latest = @{
        Streams = [ordered] @{
        }
    }

    $uniqueVersions = $download | ForEach-Object {  [Version] $_.Version; } | ForEach-Object { "$($_.Major).$($_.Minor)" } | Sort-Object -Unique -Descending

    $uniqueVersions | ForEach-Object {
        $stream = GetStream $download "$_.0.0"

        if ($stream) {
            $latest.Streams.Add($_, $stream)
        }
    }

    $latest
}

function global:au_AfterUpdate ($Package) {
    $Package.NuspecXml.package.metadata.releaseNotes = $Latest.ReleaseNotes
    $Package.SaveNuspec()

    VirusTotal_AfterUpdate $Package
}

update -ChecksumFor 32