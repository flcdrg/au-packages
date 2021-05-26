import-module au

function global:au_SearchReplace {
    @{
        'tools\chocolateyInstall.ps1' = @{
            "(^[$]filename\s*=\s*)('.*')"      = "`$1'$($Latest.Filename)'"
            "(^[$]checksum\s*=\s*)('.*')" = "`$1'$($Latest.Checksum32)'"
            "(^[$]url\s*=\s*)(['`"].*['`"])"      = "`$1'$($Latest.Url32)'"
        }
        'resharper-platform.nuspec' = @{
            "(\<title\>).*?(\</title\>)" = "`${1}JetBrains ReSharper Ultimate Platform Installer $($Latest.MarketingVersion)`$2"
        }        
     }
}

. .\common.ps1

function global:au_GetLatest {
    return GetJetbrainsReSharperPlatformLatest
}

function global:au_AfterUpdate ($Package)  {

    if ($Package.RemoteVersion -ne $Package.NuspecVersion) {

        Get-RemoteFiles -NoSuffix

        $file = [IO.Path]::Combine("tools", $Latest.FileName32)

        Write-Output "Submitting file $file to VirusTotal"

        # Assumes vt-cli Chocolatey package is installed!
        vt.exe scan file $file --apikey $env:VT_APIKEY

        Remove-Item $file -ErrorAction Ignore

        $Latest.Remove("FileName32")
    }
}

update -ChecksumFor none