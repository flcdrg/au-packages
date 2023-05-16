import-module au

. ..\_scripts\Submit-VirusTotal.ps1

Add-Type -AssemblyName System.Xml.Linq

function global:au_SearchReplace {
    @{
        'tools\chocolateyInstall.ps1' = @{
            "(^[$]url\s*=\s*)('.*')"      = "`$1'$($Latest.URL32)'"
            "(^[$]checksum\s*=\s*)('.*')" = "`$1'$($Latest.Checksum32)'"
            "(^[$]checksumType\s*=\s*)('.*')" = "`$1'$($Latest.ChecksumType32)'"
        }
        "$($Latest.PackageName).nuspec" = @{
            "(\<releaseNotes\>).*?(\</releaseNotes\>)" = "`${1}$($Latest.ReleaseNotes)`$2"
        }
    }
}

function global:au_GetLatest {
    $compareVersion = [Version] "0.0.0.0"

    $cabUrl = "https://downloads.dell.com/catalog/CatalogPC.cab"
    $downloadedFile = [IO.Path]::GetTempFileName()

    $client = new-object System.Net.WebClient
    $client.DownloadFile($cabUrl, $downloadedFile)

    $xmlFile = [io.Path]::Combine([IO.Path]::GetTempPath(), "CatalogPC.xml")

    & expand $downloadedFile $xmlFile

#   <SoftwareComponent schemaVersion="2.0" identifier="5abea4d5-82fb-4d78-bf55-ac022ed3af20" packageID="DDVDP" releaseID="DDVDP" hashMD5="bd2a08db415991ab2b9605737d26a187" path="FOLDER05055451M/1/Dell-Command-Update_DDVDP_WIN_2.4.0_A00.EXE" dateTime="2018-06-27T18:26:44+00:00" releaseDate="June 27, 2018" vendorVersion="2.4.0" dellVersion="A00" packageType="LWXP" rebootRequired="false" size="99823472">
#     <Name>
#       <Display lang="en"><![CDATA[Dell Command | Update,2.4.0,A00]]></Display>
#     </Name>
#     <ComponentType value="APAC">
#       <Display lang="en"><![CDATA[Application]]></Display>
#     </ComponentType>
#     <Description>
#       <Display lang="en"><![CDATA[This Win 32 package provides the Dell Command | Update Application and is supported on OptiPlex, Venue Pro Tablet, Precision, XPS Notebook and Latitude models that are running the following Windows operating systems: Windows 7,Windows 8, Windows 8.1 and Windows 10.]]></Display>
#     </Description>
#     <Category value="SM">
#       <Display lang="en"><![CDATA[OpenManage Systems Management]]></Display>
#     </Category>
#     <SupportedDevices>
#       <Device componentID="23400" embedded="1">
#         <Display lang="en"><![CDATA[Dell Command | Update]]></Display>
#       </Device>
#     </SupportedDevices>

    $f = [System.Xml.XmlReader]::create($xmlFile)

    while ($f.read()) {
        switch ($f.NodeType) {
                ([System.Xml.XmlNodeType]::Element) {
                if ($f.Name -eq "SoftwareComponent") {
                    $e = [System.Xml.Linq.XElement]::ReadFrom($f)

                    if ($e.Element("SupportedDevices") -and $e.Element("SupportedDevices").Element("Device")) {

                        $componentID = $e.Element("SupportedDevices").Element("Device").Attribute("componentID").Value

                    if ($componentID -eq "23400") # This is the magic number for Dell Command Update
                    {
                            $newVersion = $e.Attribute("vendorVersion").Value
                            if ($compareVersion -lt ([version] $newVersion)) {
                                $version = $newVersion
                                # FOLDER04358530M/2/Systems-Management_Application_X79N4_WN32_2.3.1_A00_01.EXE
                                $url = "https://downloads.dell.com/" + $e.Attribute("path").Value
                                $description = $e.Element("Description").Element("Display").Value
                                $releaseNotes = $e.Element("ImportantInfo").Attribute("URL").Value

                                $checksum = $e.Attribute("hashMD5").Value
                                $checksumType = "md5"

                                $compareVersion = [version] $newVersion
                            }
                        }
                    }
                }
            }
        }
    }
    $f.Dispose()

    $cabs = "https://downloads.dell.com/FOLDER08398967M/1/Latitude_0A36.cab", "https://downloads.dell.com/FOLDER10050879M/1/XPS_Notebook_0BEB.cab"

    foreach ($cabUrl in $cabs) {
        $downloadedFile = [IO.Path]::GetTempFileName()

        $client = new-object System.Net.WebClient
        $client.DownloadFile($cabUrl, $downloadedFile)

        $xmlFile = [io.Path]::Combine([IO.Path]::GetTempPath(), "CatalogPC.xml")

        & expand $downloadedFile $xmlFile

    # <SoftwareComponent schemaVersion="3.0" releaseID="W4HP2" releaseDate="April 01, 2022" vendorVersion="4.5.0" dellVersion="A00" packageType="LWXP" path="FOLDER08334841M/4/Dell-Command-Update-Application_W4HP2_WIN_4.5.0_A00_02.EXE" packageID="W4HP2" dateTime="2022-01-06T13:13:39+05:30" size="31297992" identifier="ac083258-cc0c-4dda-9318-21d5836e262b">
    # <Name>
    #     <Display lang="en"><![CDATA[Dell Command | Update Application]]></Display>
    # </Name>
    # <ComponentType value="APAC">
    #     <Display lang="en"><![CDATA[Application]]></Display>
    # </ComponentType>
    # <Description>
    #     <Display lang="en"><![CDATA[This package contains the Dell Command | Update application. Dell Command Update is a stand-alone application for client systems, that provides updates for system software that is released by Dell. This application simplifies the BIOS, firmware, driver, and application update experience for Dell client hardware.]]></Display>
    # </Description>
    # <Category value="SM">
    #     <Display lang="en"><![CDATA[Systems Management]]></Display>
    # </Category>
    # <SupportedDevices>
    #     <Device componentID="23400" embedded="false">
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
    #     <OperatingSystem osCode="W10P4" osVendor="Microsoft" osArch="x64" majorVersion="10" minorVersion="0" spMajorVersion="0" spMinorVersion="0">
    #     <Display lang="en"><![CDATA[Windows 10 64-Bit]]></Display>
    #     </OperatingSystem>
    #     <OperatingSystem osCode="WB32" osVendor="Microsoft" osArch="x86" majorVersion="6" minorVersion="3" spMajorVersion="0" spMinorVersion="0">
    #     <Display lang="en"><![CDATA[Windows 8.1 32-bit]]></Display>
    #     </OperatingSystem>
    #     <OperatingSystem osCode="IOTL3" osVendor="Microsoft" osArch="x64" majorVersion="10" minorVersion="0" spMajorVersion="0" spMinorVersion="0">
    #     <Display lang="en"><![CDATA[Windows 10 64-Bit]]></Display>
    #     </OperatingSystem>
    #     <OperatingSystem osCode="W7H32" osVendor="Microsoft" osArch="x86" majorVersion="6" minorVersion="1" spMajorVersion="0" spMinorVersion="0">
    #     <Display lang="en"><![CDATA[Windows 7 32-bit]]></Display>
    #     </OperatingSystem>
    #     <OperatingSystem osCode="WB64" osVendor="Microsoft" osArch="x64" majorVersion="6" minorVersion="3" spMajorVersion="0" spMinorVersion="0">
    #     <Display lang="en"><![CDATA[Windows 8.1 64-bit]]></Display>
    #     </OperatingSystem>
    #     <OperatingSystem osCode="WEL16" osVendor="Microsoft" osArch="x64" majorVersion="10" minorVersion="0" spMajorVersion="0" spMinorVersion="0">
    #     <Display lang="en"><![CDATA[Windows 10 64-Bit]]></Display>
    #     </OperatingSystem>
    #     <OperatingSystem osCode="W7HP6" osVendor="Microsoft" osArch="x64" majorVersion="6" minorVersion="1" spMajorVersion="0" spMinorVersion="0">
    #     <Display lang="en"><![CDATA[Windows 7 64-bit]]></Display>
    #     </OperatingSystem>
    #     <OperatingSystem osCode="W7Pr6" osVendor="Microsoft" osArch="x64" majorVersion="6" minorVersion="1" spMajorVersion="0" spMinorVersion="0">
    #     <Display lang="en"><![CDATA[Windows 7 64-bit]]></Display>
    #     </OperatingSystem>
    #     <OperatingSystem osCode="W7P32" osVendor="Microsoft" osArch="x86" majorVersion="6" minorVersion="1" spMajorVersion="0" spMinorVersion="0">
    #     <Display lang="en"><![CDATA[Windows 7 32-bit]]></Display>
    #     </OperatingSystem>
    #     <OperatingSystem osCode="W10H2" osVendor="Microsoft" osArch="x86" majorVersion="10" minorVersion="0" spMajorVersion="0" spMinorVersion="0">
    #     <Display lang="en"><![CDATA[Windows 10 32-Bit]]></Display>
    #     </OperatingSystem>
    #     <OperatingSystem osCode="W7HP3" osVendor="Microsoft" osArch="x86" majorVersion="6" minorVersion="1" spMajorVersion="0" spMinorVersion="0">
    #     <Display lang="en"><![CDATA[Windows 7 32-bit]]></Display>
    #     </OperatingSystem>
    #     <OperatingSystem osCode="W21H4" osVendor="Microsoft" osArch="x64" majorVersion="10" minorVersion="0" spMajorVersion="0" spMinorVersion="0">
    #     <Display lang="en"><![CDATA[Windows 11]]></Display>
    #     </OperatingSystem>
    #     <OperatingSystem osCode="IOT01" osVendor="Microsoft" osArch="x64" majorVersion="10" minorVersion="0" spMajorVersion="0" spMinorVersion="0">
    #     <Display lang="en"><![CDATA[Windows 10 64-Bit]]></Display>
    #     </OperatingSystem>
    #     <OperatingSystem osCode="WB32P" osVendor="Microsoft" osArch="x86" majorVersion="6" minorVersion="3" spMajorVersion="0" spMinorVersion="0">
    #     <Display lang="en"><![CDATA[Windows 8.1 32-bit]]></Display>
    #     </OperatingSystem>
    #     <OperatingSystem osCode="W10P2" osVendor="Microsoft" osArch="x86" majorVersion="10" minorVersion="0" spMajorVersion="0" spMinorVersion="0">
    #     <Display lang="en"><![CDATA[Windows 10 32-Bit]]></Display>
    #     </OperatingSystem>
    #     <OperatingSystem osCode="W21P4" osVendor="Microsoft" osArch="x64" majorVersion="10" minorVersion="0" spMajorVersion="0" spMinorVersion="0">
    #     <Display lang="en"><![CDATA[Windows 11]]></Display>
    #     </OperatingSystem>
    #     <OperatingSystem osCode="W7H64" osVendor="Microsoft" osArch="x64" majorVersion="6" minorVersion="1" spMajorVersion="0" spMinorVersion="0">
    #     <Display lang="en"><![CDATA[Windows 7 64-bit]]></Display>
    #     </OperatingSystem>
    #     <OperatingSystem osCode="W10H4" osVendor="Microsoft" osArch="x64" majorVersion="10" minorVersion="0" spMajorVersion="0" spMinorVersion="0">
    #     <Display lang="en"><![CDATA[Windows 10 64-Bit]]></Display>
    #     </OperatingSystem>
    # </SupportedOperatingSystems>
    # <ImportantInfo URL="https://www.dell.com/support/home/us/en/19/Drivers/DriversDetails?driverId=W4HP2">
    #     <Display lang="en"><![CDATA[NA]]></Display>
    # </ImportantInfo>
    # <Criticality value="1">
    #     <Display lang="en"><![CDATA[Recommended]]></Display>
    # </Criticality>
    # <Cryptography>
    #     <Hash algorithm="MD5">5f199e6770b8477f4d095db3dee222a1</Hash>
    #     <Hash algorithm="SHA256">c090c94dc313b26415effb508f904e45e36b1833023ab86c76c49150d3d520f9</Hash>
    #     <Hash algorithm="SHA1">021d63d4fe018b5cc8e6a39d92feb3a0be63b8c7</Hash>
    # </Cryptography>
    # <SharedModules>
    #     <SharedModule moduleID="107714" />
    # </SharedModules>
    # </SoftwareComponent>

        $f = [System.Xml.XmlReader]::create($xmlFile)

        while ($f.read()) {
            switch ($f.NodeType) {
                    ([System.Xml.XmlNodeType]::Element) {
                    if ($f.Name -eq "SoftwareComponent") {
                        $e = [System.Xml.Linq.XElement]::ReadFrom($f)

                        $ns = [System.Xml.Linq.XNamespace] "openmanage/cm/dm"

                        if ($e.Element($ns + "SupportedDevices") -and $e.Element($ns + "SupportedDevices").Element($ns + "Device")) {

                            $componentID = $e.Element($ns + "SupportedDevices").Element($ns + "Device").Attribute("componentID").Value

                            if ($componentID -eq "23400") { # This is the magic number for Dell Command Update
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
        }
        $f.Dispose()
    }

    $Latest = @{
        URL32          = $url
        Version        = $version
        Checksum32     = $checksum
        ChecksumType32 = $checksumType
        Description    = $description
        ReleaseNotes   = $releaseNotes
    }
    return $Latest
}

function global:au_AfterUpdate ($Package) {

    $Package.NuspecXml.package.metadata.releaseNotes = $Latest.ReleaseNotes
    $Package.SaveNuspec()

    VirusTotal_AfterUpdate $Package
}

update -ChecksumFor none