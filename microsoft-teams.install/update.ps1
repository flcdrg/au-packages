Import-Module chocolatey-au

function global:au_SearchReplace {
    @{
        'tools\chocolateyInstall.ps1' = @{
            "(^[$]url64\s*=\s*)('.*')"      = "`$1'$($Latest.URL64)'"
            "(^[$]url32\s*=\s*)('.*')"      = "`$1'$($Latest.URL32)'"
            "(^[$]checksum32\s*=\s*)('.*')" = "`$1'$($Latest.Checksum32)'"
            "(^[$]checksum64\s*=\s*)('.*')" = "`$1'$($Latest.Checksum64)'"
        }
     }
}

function global:au_GetLatest {
    # 32bit
    # https://statics.teams.cdn.office.net/production-windows/1.8.00.27654/Teams_windows.msi
    $url32 = "http://aka.ms/teams32bitmsi"
    for ($i = 0; ($i -lt 4) -and (-not ($url32.EndsWith(".msi"))); $i++) {
        $response = Invoke-WebRequest -Uri $url32 -Method Head -MaximumRedirection 0 -SkipHttpErrorCheck -ErrorAction Ignore

        $url32 = $response.Headers.Location[0]
    }

    if ($i -ge 3) {
        Write-Warning "Couldn't resolve $url32 to an .msi download URL"
        return 'Ignore'
    }

    # https://statics.teams.cdn.office.net/production-windows-x64/1.8.00.27654/Teams_windows_x64.msi

    $url64 = "http://aka.ms/teams64bitmsi"
    for ($i = 0; ($i -lt 4) -and (-not ($url64.EndsWith(".msi"))); $i++) {
        $response = Invoke-WebRequest -Uri $url64 -Method Head -MaximumRedirection 0 -SkipHttpErrorCheck -ErrorAction Ignore

        $url64 = $response.Headers.Location[0]
    }

    if ($i -ge 3) {
        Write-Warning "Couldn't resolve $url64 to an .msi download URL"
        return 'Ignore'
    }
    
    $url32 -match ".*\/(?<version>\d+\.\d+\.\d+\.\d+)\/Teams_windows\.msi"

    $version = $Matches.version
    
    $Latest = @{ URL32 = $url32; URL64 = $url64; Version = $version }
    return $Latest
}

update
