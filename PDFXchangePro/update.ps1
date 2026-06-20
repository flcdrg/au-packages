#Import-Module chocolatey-au
Import-Module "$PSScriptRoot\..\..\chocolatey-au\src\chocolatey-au.psm1"

function global:au_SearchReplace {
    @{
        'tools\chocolateyInstall.ps1' = @{
            "(^[$]checksum\s*=\s*)('.*')" = "`$1'$($Latest.Checksum32)'"
            "(^[$]checksum64\s*=\s*)('.*')" = "`$1'$($Latest.Checksum64)'"
            "(^[$]url\s*=\s*)('.*')" = "`$1'$($Latest.url)'"
            "(^[$]url64\s*=\s*)('.*')" = "`$1'$($Latest.url64)'"
        }
     }
}

function global:au_GetLatest {

    try {
        $response = Invoke-RestMethod -Uri "https://www.pdf-xchange.com/updater/UpdaterData.xml"

        # Trim off any Byte Order Mark
        $xml = [xml] $response.Trim([char] 0xFEFF, [char] 0x200B)

        $xmlNameSpace = new-object System.Xml.XmlNamespaceManager($xml.NameTable)
        # Use the namespace from the XML root element to stay compatible with schema URI changes.
        $xmlNameSpace.AddNamespace("t", $xml.DocumentElement.NamespaceURI)

        $bundleId = "Pro.x32"
        $x32update = $xml.SelectNodes("//t:bundle[@id='$bundleId']/t:update", $xmlNameSpace) | Sort-Object @{expr={[version]$_.version}; desc=$true} | Select-Object -First 1
        if (-not $x32update) { throw "Could not find updates for bundle '$bundleId' in namespace '$($xml.DocumentElement.NamespaceURI)'" }

        $version = $x32update.version
        $filename = $x32update.url

        $bundleId = "Pro.x64"
        $x64update = $xml.SelectNodes("//t:bundle[@id='$bundleId']/t:update", $xmlNameSpace) | Sort-Object @{expr={[version]$_.version}; desc=$true} | Select-Object -First 1
        if (-not $x64update) { throw "Could not find updates for bundle '$bundleId' in namespace '$($xml.DocumentElement.NamespaceURI)'" }
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
        Write-Warning $_
        return 'ignore'
    }
    return $Latest
}

update -ChecksumFor none