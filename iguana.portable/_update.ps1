Import-Module chocolatey-au

[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$releases = 'https://www.interfaceware.com/downloads.html'

function global:au_SearchReplace {
    @{
        'tools\chocolateyInstall.ps1' = @{
            "(^[$]url64\s*=\s*)('.*')"      = "`$1'$($Latest.URL64)'"
            "(^[$]checksum64\s*=\s*)('.*')" = "`$1'$($Latest.Checksum64)'"
        }
     }
}

function global:au_GetLatest {
    # Find out public version
    $download_page = Invoke-WebRequest -Uri $releases #1 
    $url64     = $download_page.links | Where-Object href -match 'iguana_noinstaller_\d.*windows_x64.zip$' | Select-Object -First 1 -expand href

    # http://dl.interfaceware.com/iguana/windows/6_1_3/iguana_noinstaller_6_1_3_windows_x64.zip
    $originalVersion = $url64 -split '/' | Select-Object -Skip 5 -First 1
    $version = $originalVersion -replace '_', '.'

    $Latest = @{ URL64 = $url64; Version = $version }
    return $Latest
}

update -ChecksumFor 64