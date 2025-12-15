Import-Module chocolatey-au

. ..\_scripts\Submit-VirusTotal.ps1

Add-Type -AssemblyName System.Xml.Linq

function global:au_SearchReplace {
    @{
        'tools\chocolateyInstall.ps1'   = @{
            "(^[$]url\s*=\s*)('.*')"          = "`$1'$($Latest.URL32)'"
            "(^[$]checksum\s*=\s*)('.*')"     = "`$1'$($Latest.Checksum32)'"
            "(^[$]checksumType\s*=\s*)('.*')" = "`$1'$($Latest.ChecksumType32)'"
        }
        "$($Latest.PackageName).nuspec" = @{
            "(\<releaseNotes\>).*?(\</releaseNotes\>)" = "`${1}$($Latest.ReleaseNotes)`$2"
        }
    }
}

function global:au_GetLatest {
    $compareVersion = [Version] "0.0.0.0"

    $cabUrl = "https://downloads.dell.com/catalog/CatalogIndexPC.cab"
    $downloadedFile = [IO.Path]::GetTempFileName()

    $client = new-object System.Net.WebClient
    $client.DownloadFile($cabUrl, $downloadedFile)

    $xmlFile = [io.Path]::Combine([IO.Path]::GetTempPath(), "CatalogIndexPC.xml")

    & expand $downloadedFile $xmlFile

    # <?xml version="1.0" encoding="utf-16"?>
    # <ManifestIndex baseLocation="downloads.dell.com" creationDateTime="2023-08-11T18:11:42+05:30" version="2023.08.11" baseLocationAccessProtocols="HTTPS" schemaVersion="3.0" xmlns="openmanage/cm/dm">
    #   <InventoryComponent inventoryCollectorType="COMPACT" schemaVersion="3.0" releaseID="08KW8" releaseDate="July 25,2023" vendorVersion="11.0.4.1" dellVersion="A00" osCode="WIN" path="FOLDER10345440M/1/InvColPC_11.0.4.1.exe" size="12000224">
    #     <Cryptography>
    #       <Hash algorithm="MD5">6cbad366dee820758c63a4822f59ea10</Hash>
    #       <Hash algorithm="SHA256">fd4fbc83532b78b8f3ce98af59bc4c65664e6d4623d85f855602e22dae93001f</Hash>
    #       <Hash algorithm="SHA1">cbb6bd4d7f1936ffa718ed564d62b7bf6e0266c1</Hash>
    #     </Cryptography>
    #   </InventoryComponent>
    #   <GroupManifest type="MTPDK" id="3686011a-5ab8-4e1c-89fe-109e2f11296b" latest="f58068ef-0fbe-4b97-8b0c-1a1489a4b1ba" eol="false" BKCCompliance="true" creationDateTime="2023-08-11T18:12:34+05:30">
    #     <Display lang="en"><![CDATA[ PDK Catalog for XPS Notebook 9530]]></Display>
    #     <SupportedSystems>
    #       <Brand key="53" prefix="XPSNOTEBOOK">
    #         <Display lang="en"><![CDATA[XPS Notebook]]></Display>
    #         <Model systemID="0BEB" systemIDType="BIOS">
    #           <Display lang="en"><![CDATA[9530]]></Display>
    #         </Model>
    #       </Brand>
    #     </SupportedSystems>
    #     <ManifestInformation id="f58068ef-0fbe-4b97-8b0c-1a1489a4b1ba" releaseID="YF49R" creationDateTime="2023-08-10T18:14:54+05:30" version="2023.08.10" path="FOLDER10470102M/1/XPS_Notebook_0BEB.cab" size="106720" inventoryCollectorType="COMPACT">
    #       <Cryptography>
    #         <Hash algorithm="MD5">8464b9c5a702b269017560eb5ae3b7fa</Hash>
    #         <Hash algorithm="SHA1">abfb5edc66ec09c860291c7efa81b2e47f616ed2</Hash>
    #         <Hash algorithm="SHA256">2df92f7f0bdad6293cced8b5e715f9fbfc2b86c9c6910c7b5bdbe245490842b1</Hash>
    #       </Cryptography>
    #       <Display lang="en"><![CDATA[ PDK Catalog for XPS Notebook 9530]]></Display>
    #     </ManifestInformation>
    #   </GroupManifest>   

    $f = [System.Xml.XmlReader]::create($xmlFile)
    $ns = [System.Xml.Linq.XNamespace] "openmanage/cm/dm"

    while ($f.read()) {
        if ($f.NodeType -eq [System.Xml.XmlNodeType]::Element) {
            if ($f.Name -eq "GroupManifest") {
                $e = [System.Xml.Linq.XElement]::ReadFrom($f)

                if ($e.Element($ns + "SupportedSystems") -and $e.Element($ns + "SupportedSystems").Element($ns + "Brand") -and $e.Element($ns + "SupportedSystems").Element($ns + "Brand").Element($ns + "Model")) {

                    $systemID = $e.Element($ns + "SupportedSystems").Element($ns + "Brand").Element($ns + "Model").Attribute("systemID").Value

                    if ($systemID -eq "0BEB") {
                        # This is the magic number for XPS 9530
                        $cabUrl = "https://downloads.dell.com/" + $e.Element($ns + "ManifestInformation").Attribute("path").Value
                        break
                    }
                }
            }
        }
        
    }
    $f.Dispose()

    $downloadedFile = [IO.Path]::GetTempFileName()

    $downloadedFile = Move-Item -Path $downloadedFile -Destination ([IO.Path]::ChangeExtension($downloadedFile, ".cab")) -Force -PassThru

    $client = new-object System.Net.WebClient
    $client.DownloadFile($cabUrl, $downloadedFile)

    $tempFolder = New-Item -ItemType Directory ([IO.Path]::Combine([IO.Path]::GetTempPath(), [IO.Path]::GetRandomFileName()))

    & expand -R $downloadedFile $tempFolder

    $xmlFile = Get-ChildItem $tempFolder -Filter *.xml -Recurse -File | Select-Object -First 1

    # <SoftwareComponent schemaVersion="3.0" releaseID="601KT" releaseDate="April 01, 2022" vendorVersion="4.5.0" dellVersion="A00" packageType="LWXP" path="FOLDER08334704M/2/Dell-Command-Update-Windows-Universal-Application_601KT_WIN_4.5.0_A00_01.EXE" packageID="601KT" dateTime="2022-01-06T13:10:24+05:30" size="33455904" identifier="df2cb539-010a-43d5-9485-9a8556fc3f11">
    # <Name>
    #     <Display lang="en"><![CDATA[Dell Command | Update Windows Universal Application]]></Display>
    # </Name>
    # <ComponentType value="APAC">
    #     <Display lang="en"><![CDATA[Application]]></Display>
    # </ComponentType>
    # <Description>
    #     <Display lang="en"><![CDATA[This package contains the Dell Command | Update Windows Universal application. Dell Command Update is a stand-alone application for client systems, that provides updates for system software that is released by Dell. This application simplifies the BIOS, firmware, driver, and application update experience for Dell client hardware. This package is compatible only with Windows 10 Anniversary Update (Redstone 1) or later, and Windows 11 operating system.]]></Display>
    # </Description>
    # <Category value="SM">
    #     <Display lang="en"><![CDATA[Systems Management]]></Display>
    # </Category>
    # <SupportedDevices>
    #     <Device componentID="107174" embedded="false">
    #     <Display><![CDATA[Dell Command | Update]]></Display>
    #     </Device>
    # </SupportedDevices>
    # <SupportedSystems>
    #     <Brand key="28" prefix="LAT">
    #     <Display lang="en"><![CDATA[Latitude]]></Display>
    #     <Model systemID="0A36">
    #         <Display lang="en"><![CDATA[7420]]></Display>
    #     </Model>
    #     </Brand>
    # </SupportedSystems>
    # <SupportedOperatingSystems>
    #     <OperatingSystem osCode="W10P2" osVendor="Microsoft" osArch="x86" majorVersion="10" minorVersion="0" spMajorVersion="0" spMinorVersion="0">
    #     <Display lang="en"><![CDATA[Windows 10 32-Bit]]></Display>
    #     </OperatingSystem>
    #     <OperatingSystem osCode="W21H4" osVendor="Microsoft" osArch="x64" majorVersion="10" minorVersion="0" spMajorVersion="0" spMinorVersion="0">
    #     <Display lang="en"><![CDATA[Windows 11]]></Display>
    #     </OperatingSystem>
    #     <OperatingSystem osCode="W10P4" osVendor="Microsoft" osArch="x64" majorVersion="10" minorVersion="0" spMajorVersion="0" spMinorVersion="0">
    #     <Display lang="en"><![CDATA[Windows 10 64-Bit]]></Display>
    #     </OperatingSystem>
    #     <OperatingSystem osCode="W10H2" osVendor="Microsoft" osArch="x86" majorVersion="10" minorVersion="0" spMajorVersion="0" spMinorVersion="0">
    #     <Display lang="en"><![CDATA[Windows 10 32-Bit]]></Display>
    #     </OperatingSystem>
    #     <OperatingSystem osCode="IOTL3" osVendor="Microsoft" osArch="x64" majorVersion="10" minorVersion="0" spMajorVersion="0" spMinorVersion="0">
    #     <Display lang="en"><![CDATA[Windows 10 64-Bit]]></Display>
    #     </OperatingSystem>
    #     <OperatingSystem osCode="W21P4" osVendor="Microsoft" osArch="x64" majorVersion="10" minorVersion="0" spMajorVersion="0" spMinorVersion="0">
    #     <Display lang="en"><![CDATA[Windows 11]]></Display>
    #     </OperatingSystem>
    #     <OperatingSystem osCode="WEL16" osVendor="Microsoft" osArch="x64" majorVersion="10" minorVersion="0" spMajorVersion="0" spMinorVersion="0">
    #     <Display lang="en"><![CDATA[Windows 10 64-Bit]]></Display>
    #     </OperatingSystem>
    #     <OperatingSystem osCode="IOT01" osVendor="Microsoft" osArch="x64" majorVersion="10" minorVersion="0" spMajorVersion="0" spMinorVersion="0">
    #     <Display lang="en"><![CDATA[Windows 10 64-Bit]]></Display>
    #     </OperatingSystem>
    #     <OperatingSystem osCode="W10H4" osVendor="Microsoft" osArch="x64" majorVersion="10" minorVersion="0" spMajorVersion="0" spMinorVersion="0">
    #     <Display lang="en"><![CDATA[Windows 10 64-Bit]]></Display>
    #     </OperatingSystem>
    # </SupportedOperatingSystems>
    # <ImportantInfo URL="https://www.dell.com/support/home/us/en/19/Drivers/DriversDetails?driverId=601KT">
    #     <Display lang="en"><![CDATA[NA]]></Display>
    # </ImportantInfo>
    # <Criticality value="1">
    #     <Display lang="en"><![CDATA[Recommended]]></Display>
    # </Criticality>
    # <Cryptography>
    #     <Hash algorithm="MD5">ab4b460cb8d831481e8ab6817589effa</Hash>
    #     <Hash algorithm="SHA256">a032355d5ac396ed28903a72345744857e40b52faadf0b4f6dc9c81d4e5f535f</Hash>
    #     <Hash algorithm="SHA1">f5de7eedc9c0b90df1e2ddd57fc0050c6d4a34a9</Hash>
    # </Cryptography>
    # <SharedModules>
    #     <SharedModule moduleID="107714" />
    # </SharedModules>
    # </SoftwareComponent>

    $f = [System.Xml.XmlReader]::create($xmlFile)

    while ($f.read()) {
        if ($f.NodeType -eq [System.Xml.XmlNodeType]::Element) {
            if ($f.Name -eq "SoftwareComponent") {
                $e = [System.Xml.Linq.XElement]::ReadFrom($f)

                $ns = [System.Xml.Linq.XNamespace] "openmanage/cm/dm"

                if ($e.Element($ns + "SupportedDevices") -and $e.Element($ns + "SupportedDevices").Element($ns + "Device")) {

                    $componentID = $e.Element($ns + "SupportedDevices").Element($ns + "Device").Attribute("componentID").Value

                    if ($componentID -eq "107174") {
                        # This is the magic number for Dell Command Update
                        $newVersion = $e.Attribute("vendorVersion").Value
                        if ($compareVersion -lt ([version] $newVersion)) {
                            $version = $newVersion
                            # FOLDER04358530M/2/Systems-Management_Application_X79N4_WN32_2.3.1_A00_01.EXE
                            $url = "https://downloads.dell.com/" + $e.Attribute("path").Value
                            $description = $e.Element($ns + "Description").Element($ns + "Display").Value
                            $releaseNotes = $e.Element($ns + "ImportantInfo").Attribute("URL").Value

                            # schemaVersion 3.0
                            $checksum = ($e.Element($ns + "Cryptography").Elements() | Where-Object { $_.Attribute("algorithm").Value -eq "SHA256" }).Value
                            $checksumType = "sha256"

                            $compareVersion = [version] $newVersion
                        }
                    }
                }
            }
        }
    }
    $f.Dispose()

    $Latest = @{
        URL32          = $url.Replace("https://downloads.dell.com/", "https://dl.dell.com/")
        Version        = $version
        Checksum32     = $checksum
        ChecksumType32 = $checksumType
        Description    = $description
        ReleaseNotes   = $releaseNotes
        Options        = @{
            Headers = @{
                'User-Agent' = 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.3'
            }
        }    
    }
    return $Latest
}

function global:au_AfterUpdate ($Package) {

    $Package.NuspecXml.package.metadata.releaseNotes = $Latest.ReleaseNotes
    $Package.SaveNuspec()

    VirusTotal_AfterUpdate $Package
}

update -ChecksumFor none