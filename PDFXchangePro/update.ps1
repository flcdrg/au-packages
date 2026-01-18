Import-Module chocolatey-au

function global:au_SearchReplace {
    @{
        'tools\chocolateyInstall.ps1' = @{
            "(^[$]checksum\s*=\s*)('.*')" = "`$1'$($Latest.Checksum32)'"
            "(^[$]checksum64\s*=\s*)('.*')" = "`$1'$($Latest.Checksum64)'"
            "(^[$]filename\s*=\s*)('.*')" = "`$1'$($Latest.Filename32)'"
            "(^[$]filename64\s*=\s*)('.*')" = "`$1'$($Latest.Filename64)'"
            "(^[$]url\s*=\s*)('.*')" = "`$1'$($Latest.url)'"
            "(^[$]url64\s*=\s*)('.*')" = "`$1'$($Latest.url64)'"
        }
     }
}

function global:au_GetLatest {

    try {
        $response = Invoke-RestMethod -Uri "https://downloads.pdf-xchange.com/trackerupdate/TrackerData8.xml"

        # Trim off any Byte Order Mark
        $xml = [xml] $response.Trim([char] 0xFEFF, [char] 0x200B)

        $xmlNameSpace = new-object System.Xml.XmlNamespaceManager($xml.NameTable)
        $xmlNameSpace.AddNamespace("t", "http://schemas.tracker-software.com/trackerupdate/tb/v1")

        $bundleId = "Pro.x32"
        $x32update = $xml.SelectNodes("//t:bundle[@id='$bundleId']/t:update", $xmlNameSpace) | Sort-Object @{expr={[version]$_.version}; desc=$true} | Select-Object -First 1
        $version = $x32update.version
        $filename = $x32update.url

        $bundleId = "Pro.x64"
        $x64update = $xml.SelectNodes("//t:bundle[@id='$bundleId']/t:update", $xmlNameSpace) | Sort-Object @{expr={[version]$_.version}; desc=$true} | Select-Object -First 1
        $filename64 = $x64update.url

        $primaryDownloadUrl = "https://downloads.pdf-xchange.com/$version/$filename"
        $primaryDownloadUrl64 = "https://downloads.pdf-xchange.com/$version/$filename64"

        $response = Invoke-WebRequest $primaryDownloadUrl -Method Head -UseBasicParsing

        if ($response.StatusCode -ne 200) {
            throw "Failed to access $primaryDownloadUrl"
        }

        $response = Invoke-WebRequest $primaryDownloadUrl64 -Method Head -UseBasicParsing
        if ($response.StatusCode -ne 200) {
            throw "Failed to access $primaryDownloadUrl64"
        }

        $Latest = @{ 
            Version = $version
            Checksum32 = $x32update.hash
            Checksum64 = $x64update.hash
            Filename32 = $filename
            Filename64 = $filename64
            url = $primaryDownloadUrl
            url64 = $primaryDownloadUrl64
        }
    }
    catch {
        $Latest = @{}
        Write-Error $_
    }
    return $Latest
}

update -ChecksumFor none