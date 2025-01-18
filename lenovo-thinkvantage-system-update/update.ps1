Import-Module chocolatey-au

. ../_scripts/common.ps1

function global:au_SearchReplace {
    @{
        'tools\chocolateyInstall.ps1' = @{
            "(^[$]url\s*=\s*)('.*')"      = "`$1'$($Latest.URL32)'"
            "(^[$]checksum\s*=\s*)('.*')" = "`$1'$($Latest.Checksum32)'"
        }
     }
}

function createLatest($version, $buildDate) {
    return @{
        URL32 = "https://download.lenovo.com/pccbbs/thinkvantage_en/system_update_$($version).exe";
        ReleaseNotes = "$buildDate release - https://download.lenovo.com/pccbbs/thinkvantage_en/system_update_$($version).txt"
        Version = $version 
    }
}

function global:au_GetLatest {

    # Unfortunately, they're including a Byte Order Mark, so we have to trim that off
    # I wonder if we should increment this number in the download each time we find an update?
    $response = Invoke-RestMethod -Uri "https://download.lenovo.com/ibmdl/pub/pc/pccbbs/agent/SSClientCommon/HelloLevel_9_59_00.xml"

    if ($response.Length -gt 0) {
        $xml = [xml] $response.Substring(3)
        $version = $xml.LevelDescriptor.Version
        $buildDate = $xml.LevelDescriptor.BuildDate
    }
    
    $Latest = createLatest $version $buildDate

    # Sometimes the version might be wrong, so check first
    try {
        Get-redirectedUri $Latest.URL32
    }
    catch {
        # Fallback to scraping the webpage
        $response = Invoke-WebRequest -Uri "https://support.lenovo.com/us/en/downloads/ds012808-lenovo-system-update-for-windows-10-7-32-bit-64-bit-desktop-notebook-workstation" -UseBasicParsing
        $pattern = '(?<="Name":"Lenovo\ System\ Update")[\S\s]*,"Version":"(?<Version>[\d\.]+)'
        $version = [regex]::Match($response.Content, $pattern).groups['Version'].value
        $pattern = '(?<="Name":"Lenovo\ System\ Update")[\S\s]*,"Date":\{"Unix":(?<Date>\d+)\}'
        $unixTime = [regex]::Match($response.Content, $pattern).groups['Date'].value
        $buildDate = [System.DateTimeOffset]::FromUnixTimeMilliseconds($unixTime).DateTime.ToString("d MMM yyyy")
        
        $Latest = createLatest $version $buildDate
    }

    return $Latest
}

function global:au_AfterUpdate
{ 
    $nuspecFileName = $Latest.PackageName + ".nuspec"
    $nu = Get-Content $nuspecFileName -Raw -Encoding UTF8
    $nu = $nu -replace "(?smi)(\<releaseNotes\>).*?(\</releaseNotes\>)", "`${1}$($Latest.ReleaseNotes)`$2"
    
    $Utf8NoBomEncoding = New-Object System.Text.UTF8Encoding($False)
    $NuPath = (Resolve-Path $NuspecFileName)
    [System.IO.File]::WriteAllText($NuPath, $nu, $Utf8NoBomEncoding)
}

update -NoReadme
