Import-Module chocolatey-au
#Import-Module "$PSScriptRoot\..\..\chocolatey-au\src\chocolatey-au.psm1"

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

        # Need to pick the newest one. eg.
        # <update version="9.2.358.0" minVersionUpdate="5.5.308.0" type="msi" platform="x32" size="221208576" url="builds-archive/9.2.358.0/EditorV9.x86.msi" hash="66C2CFA622DE03EC82035E650BC7677A21D85EB8DE3BF6EC3B88CA2593D542B8" startMaintenance="2021-10-18" cmdLineSilent="/qb /norestart"/>
        # <update version="9.2.359.0" minVersionUpdate="5.5.308.0" type="msi" platform="x32" size="221298688" url="EditorV9.x86.msi" hash="51DF7E30E47AE312E181A6CEED871FDEB2C2E08A2F935A95CE92F15B4D6CC2F7" startMaintenance="2021-11-23" cmdLineSilent="/qb /norestart"/>

        $bundleId = "Editor.x32"
        $x32update = $xml.SelectNodes("//t:bundle[@id='$bundleId']/t:update", $xmlNameSpace) | Sort-Object @{expr={[version]$_.version}; desc=$true} | Select-Object -First 1
        if (-not $x32update) { throw "Could not find updates for bundle '$bundleId' in namespace '$($xml.DocumentElement.NamespaceURI)'" }
        $version = $x32update.version
        $filename = $x32update.url

        $bundleId = "Editor.x64"
        $x64update = $xml.SelectNodes("//t:bundle[@id='$bundleId']/t:update", $xmlNameSpace) | Sort-Object @{expr={[version]$_.version}; desc=$true} | Select-Object -First 1
        if (-not $x64update) { throw "Could not find updates for bundle '$bundleId' in namespace '$($xml.DocumentElement.NamespaceURI)'" }
        $filename64 = $x64update.url

        # https://downloads.pdf-xchange.com/11.0.1.0/EditorV11.x64.msi
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