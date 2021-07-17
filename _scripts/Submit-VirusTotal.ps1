<#
.SYNOPSIS
    Submit file(s) to VirusTotal
.NOTES
    Call from global:au_AfterUpdate
#>
function VirusTotal_AfterUpdate ($Package)  {

    if ($Package.RemoteVersion -ne $Package.NuspecVersion) {

        Get-RemoteFiles -NoSuffix

        if ($Latest.FileName32) {
            $file = [IO.Path]::Combine("tools", $Latest.FileName32)

            Write-Output "Submitting file $file to VirusTotal"

            # Assumes vt-cli Chocolatey package is installed!
            vt.exe scan file $file --apikey $env:VT_APIKEY

            Remove-Item $file -ErrorAction Ignore

            $Latest.Remove("FileName32")
        }

        if ($Latest.FileName64) {
            $file = [IO.Path]::Combine("tools", $Latest.FileName64)

            Write-Output "Submitting file $file to VirusTotal"
    
            # Assumes vt-cli Chocolatey package is installed!
            vt.exe scan file $file --apikey $env:VT_APIKEY
    
            Remove-Item $file -ErrorAction Ignore
    
            $Latest.Remove("FileName64")
        }
    }
}