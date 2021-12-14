import-module au

function global:au_SearchReplace {
    $d32 = [DateTimeOffset] $Latest.LastModified32
    $d64 = [DateTimeOffset] $Latest.LastModified64

    @{
        'tools\chocolateyInstall.ps1' = @{
            "(^[$]checksum\s*=\s*)('.*')" = "`$1'$($Latest.Checksum32)'"
            "(^[$]checksum64\s*=\s*)('.*')" = "`$1'$($Latest.Checksum64)'"
            "(^[$]lastModified32\s*=\s*)(.*)(\s+\#)" = "`$1New-Object -TypeName DateTimeOffset $($d32.Year), $($d32.Month), $($d32.Day), $($d32.Hour), $($d32.Minute), $($d32.Second), 0`$3"
            "(^[$]lastModified64\s*=\s*)(.*)(\s+\#)" = "`$1New-Object -TypeName DateTimeOffset $($d64.Year), $($d64.Month), $($d64.Day), $($d64.Hour), $($d64.Minute), $($d64.Second), 0`$3"
            "(^[$]filename\s*=\s*)('.*')" = "`$1'$($Latest.Filename32)'"
            "(^[$]filename64\s*=\s*)('.*')" = "`$1'$($Latest.Filename64)'"
        }
     }
}

function global:au_GetLatest {

    try {
        $response = Invoke-RestMethod -Uri "https://www.tracker-software.com/trackerupdate/TrackerData8.xml"

        # Unfortunately, they're including a Byte Order Mark, so we have to trim that off
        $xml = [xml] $response.Substring(3)

        $xmlNameSpace = new-object System.Xml.XmlNamespaceManager($xml.NameTable)
        $xmlNameSpace.AddNamespace("t", "http://schemas.tracker-software.com/trackerupdate/tb/v1")

        # Need to pick the newest one. eg.
        # <update version="9.2.358.0" minVersionUpdate="5.5.308.0" type="msi" platform="x32" size="221208576" url="builds-archive/9.2.358.0/EditorV9.x86.msi" hash="66C2CFA622DE03EC82035E650BC7677A21D85EB8DE3BF6EC3B88CA2593D542B8" startMaintenance="2021-10-18" cmdLineSilent="/qb /norestart"/>
        # <update version="9.2.359.0" minVersionUpdate="5.5.308.0" type="msi" platform="x32" size="221298688" url="EditorV9.x86.msi" hash="51DF7E30E47AE312E181A6CEED871FDEB2C2E08A2F935A95CE92F15B4D6CC2F7" startMaintenance="2021-11-23" cmdLineSilent="/qb /norestart"/>

        $bundleId = "Editor.x32"
        $x32update = $xml.SelectNodes("//t:bundle[@id='$bundleId']/t:update", $xmlNameSpace) | Sort-Object -Descending -Property startMaintenance | Select-Object -First 1
        $version = $x32update.version
        $filename = $x32update.url

        $bundleId = "Editor.x64"
        $x64update = $xml.SelectNodes("//t:bundle[@id='$bundleId']/t:update", $xmlNameSpace) | Sort-Object -Descending -Property startMaintenance | Select-Object -First 1
        $filename64 = $x64update.url

        $response = Invoke-WebRequest "http://downloads.pdf-xchange.com/$filename" -Method Head -UseBasicParsing
        $lastModifiedHeader = $response.Headers.'Last-Modified'
        $x86lastModified = [DateTimeOffset]::Parse($lastModifiedHeader, [Globalization.CultureInfo]::InvariantCulture)

        $response = Invoke-WebRequest "http://downloads.pdf-xchange.com/$filename64" -Method Head -UseBasicParsing
        $lastModifiedHeader = $response.Headers.'Last-Modified'
        $x64lastModified = [DateTimeOffset]::Parse($lastModifiedHeader, [Globalization.CultureInfo]::InvariantCulture)

        $Latest = @{ 
            Version = $version
            Checksum32 = $x32update.hash
            Checksum64 = $x64update.hash
            LastModified32 = $x86lastModified
            LastModified64 = $x64lastModified
            Filename32 = $filename
            Filename64 = $filename64
        }
    }
    catch {
        $Latest = @{}
        Write-Error $_
    }
    return $Latest
}

update -ChecksumFor none