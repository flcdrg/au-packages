function Get-TeamCityLatest([version] $minimumVersion = "2017.2") {
    $response = Invoke-RestMethod "https://www.jetbrains.com/teamcity/update.xml"

    $latest = @{
        Streams = [ordered] @{
        }
    }

    $response.products.product | Where-Object { $_.code -eq "TC" } | Select-Object -ExpandProperty channel | Where-Object { $_.status -eq "release" -and ([version]$_.build.version -ge $minimumVersion) } | Sort-Object @{expr={[version]$_.version}} -Descending | ForEach-Object {

        $version = $_.build.version
        $buildNumber = $_.build.number
        $releaseNotes = $_.build.link | Where-Object { $_.rel -eq "releaseNotes" } | Select-Object -ExpandProperty href

        if (-not ($releaseNotes)) {
            # If there wasn't a link in the payload (which appears to be the case for older releases), then make one up following this convention:
            # https://confluence.jetbrains.com/display/TW/TeamCity+2018.2.1+(build+61078)+Release+Notes
            $releaseNotes = "https://confluence.jetbrains.com/display/TW/TeamCity+$($version)+(build+$($buildNumber))+Release+Notes"
        }

        $latest.Streams.Add($_.id,
            @{
                Version = $version
                Checksum32 = $_.build.distribution.sha256
                ReleaseNotes = $releaseNotes
                Filename = "TeamCity-$version.tar.gz"
                Url32 = "https://download.jetbrains.com/teamcity/TeamCity-$version.tar.gz"
            }
        )
    }
    
    $latest
}

function global:au_GetLatest {
    return Get-TeamCityLatest
}