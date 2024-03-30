Import-Module chocolatey-au

# For Get-ChocolateyUnzip
Import-Module "$Env:ChocolateyInstall\helpers\chocolateyInstaller.psm1" -Force -Scope Local

function global:au_SearchReplace {
   @{
        ".\tools\chocolateyInstall.ps1" = @{
            "(?i)(^\s*\`$checksum\s*=\s*)('.*')"     = "`$1'$($Latest.Checksum32)'"
            "(?i)(^\s*\`$relativePath\s*=\s*)('.*')"     = "`$1'$($Latest.RelativePath)'"
        }
    }
}

function global:au_GetLatest {
    $url = 'https://update.rode.com/connect/RODE_Connect_WIN.zip'
   
    $zipfile = "$PSScriptRoot\RODE_Connect_WIN.zip"

    Write-Host "Downloading zip file to find the version"
    $currentProgressPreference = $ProgressPreference
    $ProgressPreference = 'silentlyContinue'
    Invoke-WebRequest $url -OutFile $zipfile
    $ProgressPreference = $currentProgressPreference

    $checksum32 = Get-FileHash $zipfile | ForEach-Object Hash

    $unzipFolder = New-Item -ItemType Directory ([System.IO.Path]::Combine( $env:TEMP, [System.IO.Path]::GetRandomFileName()))
    Get-ChocolateyUnzip -fileFullPath $zipfile -destination $unzipFolder

    Remove-Item -Path $zipfile -Force

    $msiFile = Get-ChildItem -Recurse -Filter *.msi $unzipFolder | Select-Object -First 1 -ExpandProperty FullName
    $relativePath = $msiFile.Replace($unzipFolder.FullName, '').TrimStart('\')
    $version = (..\_scripts\Get-MSIInfo.ps1 -Path $msiFile -Property ProductVersion)[3]

    # Just in case they do updates without revving version
    $headers = (Invoke-WebRequest -Uri $url -Method HEAD).Headers
    $lastModified = $headers['Last-Modified'] -as [DateTimeOffset]
    $etag = $headers['ETag']

    $latest = @{
        version = $version
        lastModified = $lastModified
        eTag = $etag
    }

    if (Test-Path current.json) {
        $current = (Get-Content current.json) | ConvertFrom-Json
        if ($current.lastModified) {
            $current.lastModified = [System.DateTimeOffset] $current.lastModified
        } else {
            $current.lastModified = [System.DateTimeOffset]::MinValue
        }
    } else {
        $current = @{ version = ''; lastModified  = [DateTimeOffset]::MinValue; eTag = '' }
    }

    Write-Host $current.lastModified
    Write-host $latest.lastModified
    Write-Host ($latest.lastModified -gt $current.lastModified)
    Write-Host ($latest.eTag -ne $current.eTag)

    $json = $latest | ConvertTo-Json -Depth 1
    Set-Content -Path current.json -Value $json

    @{
        Version  = $version
        Checksum32 = $checksum32
        RelativePath = $relativePath
    }
}

update -ChecksumFor none