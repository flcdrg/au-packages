. ..\_scripts\Submit-VirusTotal.ps1


function SearchReplace($MajorVersion, $Latest) {
    @{
        #   softwareName  = 'Hotfix 3026 for Microsoft SQL Server*(KB4229789)*'
        'tools\chocolateyInstall.ps1' = @{
            "(^[$]url\s*=\s*)('.*')"      = "`$1'$($Latest.URL64)'"
            "(^[$]urlFallback\s*=\s*)('.*')" = "`$1'$($Latest.URL64Fallback)'"
            "(^[$]checksum\s*=\s*)('.*')" = "`$1'$($Latest.Checksum64)'"
            "(^[$]softwareName\s*=\s*)('.*')" = "`$1'Hotfix $($Latest.Build) for SQL Server $MajorVersion*(KB$($Latest.KB))*'"
        }
     }
}

function GetCatalogFallbackUrl($KB, $MajorVersion) {
    try {
        $searchResponse = Invoke-WebRequest -Uri "https://www.catalog.update.microsoft.com/Search.aspx?q=KB$KB SQL Server $MajorVersion" -ErrorAction Stop
    } catch {
        return $null
    }

    $availableIds = $searchResponse.InputFields |
        Where-Object { $_.type -eq 'Button' -and $_.Value -eq 'Download' } |
        Select-Object -ExpandProperty ID

    if (-not $availableIds) {
        return $null
    }

    $guids = $searchResponse.Links |
        Where-Object ID -match '_link' |
        ForEach-Object { $_.id.replace('_link', '') } |
        Where-Object { $_ -in $availableIds } |
        Select-Object -Unique

    foreach ($guid in $guids) {
        $post = @{ size = 0; updateID = $guid; uidInfo = $guid } | ConvertTo-Json -Compress
        $postBody = @{ updateIDs = "[$post]" }

        try {
            $content = Invoke-WebRequest -Uri 'https://www.catalog.update.microsoft.com/DownloadDialog.aspx' -Method Post -Headers @{ "Accept-Language" = "en-US" } -Body $postBody -ErrorAction Stop |
                Select-Object -ExpandProperty Content
        } catch {
            continue
        }

        $urls = [regex]::Matches($content, "(http[s]?)(:\/\/)([^\s,]+)(?=')") |
            ForEach-Object { $_.Value } |
            Select-Object -Unique

        $fallback = $urls |
            Where-Object { $_ -match "(?i)catalog\.s\.download\.windowsupdate\.com/.+sqlserver$MajorVersion-kb$KB-x64.*\.exe$" } |
            Select-Object -First 1

        if (-not $fallback) {
            $fallback = $urls |
                Where-Object { $_ -match "(?i)catalog\.s\.download\.windowsupdate\.com/.+kb$KB.+\.exe$" } |
                Select-Object -First 1
        }

        if ($fallback) {
            return $fallback
        }
    }

    return $null
}

function GetLatest($downloadId, $MajorVersion) {
    $response = Invoke-WebRequest -Uri "https://www.microsoft.com/en-us/download/details.aspx?id=$downloadId" -ErrorAction Ignore

    $url = $response.Content | 
        Select-String -AllMatches -Pattern "(http|ftp|https)://([\w_-]+(?:(?:\.[\w_-]+)+))([\w.,@?^=%&:/~+#-]*[\w@?^=%&/~+#-])?" | 
        ForEach-Object { $_.Matches.Value } | 
        Select-string "\.exe$" | 
        Select-Object -First 1 -ExpandProperty Line
    
    # Example values seen:
    # - Cumulative Update Package 16 for SQL Server 2022 - KB5048033
    # - Cumulative Update Package 31 Azure Connect Pack for SQL Server 2017 - KB5050533
    if ($response.Content -match "<meta name=`"description`" content=`"Cumulative Update Package\s+(\d+)\b.*?for SQL Server\s+$MajorVersion\s+-\s+KB(\d+)`"\s*\/\>") {
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
    $fallbackUrl = GetCatalogFallbackUrl $kb $MajorVersion

    $Latest = @{ 
        URL64 = $url
        URL64Fallback = $fallbackUrl
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