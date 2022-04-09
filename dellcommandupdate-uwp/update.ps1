import-module au

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

    $cabUrl = "https://downloads.dell.com/catalog/CatalogPC.cab"
    $downloadedFile = [IO.Path]::GetTempFileName()

    $client = new-object System.Net.WebClient
    $client.DownloadFile($cabUrl, $downloadedFile)

    $xmlFile = [io.Path]::Combine([IO.Path]::GetTempPath(), "CatalogPC.xml")

    & expand $downloadedFile $xmlFile

    # <SoftwareComponent schemaVersion="2.0" identifier="d0fcb1c2-8d94-46c5-8ca4-b0dac9356574" packageID="GRVPK" releaseID="GRVPK" hashMD5="c8f879a00b7dde248e52ad334962a80b" path="FOLDER07582763M/1/Dell-Command-Update-Application-for-Windows-10_GRVPK_WIN_4.3.0_A00.EXE" dateTime="2021-06-13T10:20:09Z" releaseDate="July 29, 2021" vendorVersion="4.3.0" dellVersion="A00" packageType="LWXP" size="29293632">
    # <Name>
    #   <Display lang="en"><![CDATA[Dell Command | Update Application for Windows 10,4.3.0,A00]]></Display>
    # </Name>
    # <ComponentType value="APAC">
    #   <Display lang="en"><![CDATA[Application]]></Display>
    # </ComponentType>cho
    # <Description>
    #   <Display lang="en"><![CDATA[This Universal Windows Platform (UWP) package contains the Dell Command Update for systems running the Windows 10 build 14393 (Redstone 1) or later. Dell Command Update is a stand-alone application for client systems, that provides updates for system software that is released by Dell. This application simplifies the BIOS, firmware, driver, and application update experience for Dell client hardware.]]></Display>
    # </Description>
    # <Category value="SM">
    #   <Display lang="en"><![CDATA[Systems Management]]></Display>
    # </Category>
    # <SupportedDevices>
    #   <Device componentID="107174" embedded="false">
    #     <Display lang="en"><![CDATA[Dell Command | Update]]></Display>
    #     <Dependency componentID="159" componentType="BIOS" prerequisite="6024a3d1-d256-409c-9a34-277afc5cb630" version="1.3.1" rebootToContinue="true">
    #       <Display lang="en"><![CDATA[Dependent BIOS]]></Display>
    #     </Dependency>
    #   </Device>
    # </SupportedDevices>

    $f = [System.Xml.XmlReader]::create($xmlFile)

    while ($f.read()) {
        switch ($f.NodeType) {
                ([System.Xml.XmlNodeType]::Element) {
                if ($f.Name -eq "SoftwareComponent") {
                    $e = [System.Xml.Linq.XElement]::ReadFrom($f)

                    if ($e.Element("SupportedDevices") -and $e.Element("SupportedDevices").Element("Device")) {

                        $componentID = $e.Element("SupportedDevices").Element("Device").Attribute("componentID").Value

                        if ($componentID -eq "107174") { # This is the magic number for Dell Command Update
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

    $cabUrl = "https://downloads.dell.com/FOLDER08398967M/1/Latitude_0A36.cab"
    $downloadedFile = [IO.Path]::GetTempFileName()

    $client = new-object System.Net.WebClient
    $client.DownloadFile($cabUrl, $downloadedFile)

    $xmlFile = [io.Path]::Combine([IO.Path]::GetTempPath(), "CatalogPC.xml")

    & expand $downloadedFile $xmlFile

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
        switch ($f.NodeType) {
                ([System.Xml.XmlNodeType]::Element) {
                if ($f.Name -eq "SoftwareComponent") {
                    $e = [System.Xml.Linq.XElement]::ReadFrom($f)

                    $ns = [System.Xml.Linq.XNamespace] "openmanage/cm/dm"

                    if ($e.Element($ns + "SupportedDevices") -and $e.Element($ns + "SupportedDevices").Element($ns + "Device")) {

                        $componentID = $e.Element($ns + "SupportedDevices").Element($ns + "Device").Attribute("componentID").Value

                        if ($componentID -eq "107174") { # This is the magic number for Dell Command Update
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