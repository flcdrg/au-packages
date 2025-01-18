# https://archive.synology.com/download/Utility/ActiveBackupBusinessAgent

Import-Module chocolatey-au

function global:au_SearchReplace {
    @{
        'tools\chocolateyInstall.ps1' = @{
            "(^[$]url\s*=\s*)('.*')"         = "`$1'$($Latest.Url32)'"
            "(^[$]checksum\s*=\s*)('.*')"    = "`$1'$($Latest.Checksum32)'"
            "(^[$]url64\s*=\s*)('.*')"         = "`$1'$($Latest.Url64)'"
            "(^[$]checksum64\s*=\s*)('.*')"    = "`$1'$($Latest.Checksum64)'"
        }
     }
}

function global:au_GetLatest {

    $response = Invoke-WebRequest -Uri "https://archive.synology.com/download/Utility/ActiveBackupBusinessAgent"
    $content = $response.Content

    $content -match "/download/Utility/ActiveBackupBusinessAgent/(?<version>[\d.-]+)"
    $version = $Matches.version

    $Latest = @{
        Version = $version.Replace("-", ".")
        Url32 = "https://global.download.synology.com/download/Utility/ActiveBackupBusinessAgent/$version/Windows/i686/Synology%20Active%20Backup%20for%20Business%20Agent-$version-x86.msi"
        Url64 = "https://global.download.synology.com/download/Utility/ActiveBackupBusinessAgent/$version/Windows/x86_64/Synology%20Active%20Backup%20for%20Business%20Agent-$version-x64.msi"
    }

    return $Latest
}


update