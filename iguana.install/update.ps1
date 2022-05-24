import-module au

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
    try {
        $download_page = Invoke-WebRequest -Uri $releases #1 
        $url64 = $download_page.links | Where-Object href -match 'iguana_\d.*x64.zip$' | Select-Object -First 1 -expand href

        # http://dl.interfaceware.com/iguana/windows/6_0_6/iguana_6_0_6_windows_x64.exe
        $version = ($url64 -split '/' | Select-Object -Skip 5 -First 1) -replace '_', '.'

        $Latest = @{ URL64 = $url64; Version = $version }
        return $Latest
    }
    catch {
        Write-Warning $_
        return 'ignore'
    }

}

if ($MyInvocation.InvocationName -ne '.') { # run the update only if script is not sourced
    update -ChecksumFor 64
}