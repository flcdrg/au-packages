import-module au

. ..\_scripts\Submit-VirusTotal.ps1

Add-Type -AssemblyName System.Xml.Linq

function global:au_SearchReplace {
    @{
        'tools\chocolateyInstall.ps1' = @{
            "(^[$]url\s*=\s*)('.*')"      = "`$1'$($Latest.URL32)'"
            "(^[$]checksum\s*=\s*)('.*')" = "`$1'$($Latest.Checksum32)'"
        }
        "$($Latest.PackageName).nuspec" = @{
            "(\<releaseNotes\>).*?(\</releaseNotes\>)" = "`${1}$($Latest.ReleaseNotes)`$2"
        }     
    }
}

function global:au_GetLatest {
    # http://ftp.dell.com/catalog/CatalogPC.cab

    $downloadedFile = [IO.Path]::GetTempFileName()

    $client = new-object System.Net.WebClient
    $client.DownloadFile("https://downloads.dell.com/catalog/CatalogPC.cab", $downloadedFile)

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

    $compareVersion = [Version] "0.0.0.0"

    while ($f.read())
    {
        switch ($f.NodeType)
        {
            ([System.Xml.XmlNodeType]::Element)
            {
                if ($f.Name -eq "SoftwareComponent")
                {
                    $e = [System.Xml.Linq.XElement]::ReadFrom($f)

                    $componentID = $e.Element("SupportedDevices").Element("Device").Attribute("componentID").Value

                    if ($componentID -eq "107174") # This is the magic number for Dell Command Update
                    {
                        $newVersion = $e.Attribute("vendorVersion").Value
                        if ($compareVersion -lt ([version] $newVersion)) {
                            $version = $newVersion
                            # FOLDER04358530M/2/Systems-Management_Application_X79N4_WN32_2.3.1_A00_01.EXE
                            $url = "https://downloads.dell.com/" + $e.Attribute("path").Value 
                            $checksum = $e.Attribute("hashMD5").Value
                            $description = $e.Element("Description").Element("Display").Value 
                            $releaseNotes = $e.Element("ImportantInfo").Attribute("URL").Value

                            $compareVersion = [version] $newVersion
                        }
                    }
                }
            }
        }
    }
    $f.Dispose()
    
    $Latest = @{ 
        URL32 = $url
        Version = $version
        Checksum32 = $checksum
        Description = $description
        ReleaseNotes = $releaseNotes
    }
    return $Latest
}

function global:au_AfterUpdate ($Package) {

    $Package.NuspecXml.package.metadata.releaseNotes = $Latest.ReleaseNotes
    $Package.SaveNuspec()

    VirusTotal_AfterUpdate $Package
}

update -ChecksumFor none -Force