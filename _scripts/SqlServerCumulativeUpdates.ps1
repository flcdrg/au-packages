. ..\_scripts\Submit-VirusTotal.ps1


function SearchReplace($MajorVersion, $Latest) {
    @{
        #   softwareName  = 'Hotfix 3026 for Microsoft SQL Server*(KB4229789)*'
        'tools\chocolateyInstall.ps1' = @{
            "(^[$]url\s*=\s*)('.*')"      = "`$1'$($Latest.URL64)'"
            "(^[$]checksum\s*=\s*)('.*')" = "`$1'$($Latest.Checksum64)'"
            "(^[$]softwareName\s*=\s*)('.*')" = "`$1'Hotfix $($Latest.Build) for SQL Server $MajorVersion*(KB$($Latest.KB))*'"
        }
     }
}

function GetLatest($downloadId, $MajorVersion) {
    $response = Invoke-WebRequest -Uri "https://www.microsoft.com/en-us/download/details.aspx?id=$downloadId" -ErrorAction Ignore

    $url = $response.Content | 
        Select-String -AllMatches -Pattern "(http|ftp|https)://([\w_-]+(?:(?:\.[\w_-]+)+))([\w.,@?^=%&:/~+#-]*[\w@?^=%&/~+#-])?" | 
        ForEach-Object { $_.Matches.Value } | 
        Select-string "\.exe$" | 
        Select-Object -First 1 -ExpandProperty Line
    
    # <meta name="description" content="Cumulative Update Package 16 for SQL Server 2022 - KB5048033"/>
    if ($response.Content -match "<meta name=`"description`" content=`"Cumulative Update Package (\d+) for SQL Server $MajorVersion - KB(\d+)`"\s*\/\>") {
        $cu = $Matches[1]
        $kb = $Matches[2]
    } else {
        return @{}
    }

    # Find full version number
    if ($response.Content -match "\d+\.\d+\.\d+\.\d+") {
        $version = $Matches[0]
    } else {
        return @{}
    }
    
    $v = [Version] $version
    $Latest = @{ 
        URL64 = $url
        Version = $version
        KB = $kb
        CU = $cu
        Build = $v.Build
    }

    # Check for a partial page update (has happened in the past) where the download URL doesn't change.
    # We can't do this from global:au_BeforeUpdate, because the checksum stuff has already been run (and updated the chocolateyinstall.ps1 script)
    $toolsContent = Get-Content .\tools\chocolateyinstall.ps1 -Encoding utf8

    $matched = ($toolsContent -match "(^[$]url\s*=\s*)('.*')") | Select-Object -First 1

    if ($matched -match "(^[$]url\s*=\s*)'(.*)'") {
        $script:previousUrl = $Matches[2]
    }
    return $Latest
}

function AfterUpdate ($Package, $Latest, $MajorVersion) {

    if (($Package.RemoteVersion -ne $Package.NuspecVersion) -and ($script:previousUrl -eq $Latest.URL64)) {
        # URL didn't change, game over!
        throw "New version $($Package.NuspecVersion) but URL ($($script:previousUrl)) didn't change"
    }

    $Package.NuspecXml.package.metadata.releaseNotes = "https://support.microsoft.com/help/$($Latest.KB)"
    $Package.NuspecXml.package.metadata.title = "Microsoft SQL Server $MajorVersion Cumulative Update $($Latest.CU)"
    $Package.SaveNuspec()

    VirusTotal_AfterUpdate $Package
}