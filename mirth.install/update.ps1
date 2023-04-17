import-module au

function global:au_SearchReplace {
    @{
        'tools\chocolateyInstall.ps1' = @{
            "(^\`$url\s*=\s*)('.*')"    = "`$1'$($Latest.Url32)'"
            "(^\`$checksum\s*=\s*)('.*')"   = "`$1'$($Latest.Checksum32)'"
            "(^\`$url64\s*=\s*)('.*')"    = "`$1'$($Latest.Url64)'"
            "(^\`$checksum64\s*=\s*)('.*')"   = "`$1'$($Latest.Checksum64)'"
        }
    }
}

function global:au_GetLatest {
    $token = $env:github_api_key
    $headers = @{
        'User-Agent' = 'flcdrg'
    }
    if ($token) {
        $headers['Authorization'] = ("token {0}" -f $token)
    } else {
        Write-Warning "No auth token"
    }

    $releasesUrl = "https://api.github.com/repos/nextgenhealthcare/connect/releases"
    $response = Invoke-RestMethod -Method Get -Uri "$releasesUrl/latest" -Headers $headers
    
    # Typical tag_name is version number. eg. '3.10.0'
    $version = $response.tag_name

    $Latest = @{
        Version = $version
    }

    # Download links are in body, which is markdown
    if ($response.body -match '\((https://[\w\/\.\-]+windows-x32\.exe)\)') {
        $latest.URL32 = $Matches[1]
    } else {
        # if no windows link, then not a release we care about
        return 'ignore'
    }

    if ($response.body -match '\((https://[\w\/\.\-]+windows-x64\.exe)\)') {
        $latest.URL64 = $Matches[1]
    } else {
        # if no windows link, then not a release we care about
        return 'ignore'
    }

    if ($response.body -match '\[See What''s New\]\((https://[\w\.\/\-\'']+)\)') {
        $latest.ReleaseNotes = $Matches[1]
    }

    # checksums are also in body, but probably too risky to rely on markdown being in a consistent format to use them.
    return $Latest
}

function global:au_AfterUpdate
{ 
    if ($Latest.ReleaseNotes) {
        $nuspecFileName = $Latest.PackageName + ".nuspec"
        $nu = Get-Content $nuspecFileName -Raw -Encoding UTF8
        $nu = $nu -replace "(?smi)(\<releaseNotes\>).*?(\</releaseNotes\>)", "`${1}$([System.Web.HttpUtility]::HtmlEncode($Latest.ReleaseNotes))`$2"
        
        $Utf8NoBomEncoding = New-Object System.Text.UTF8Encoding($False)
        $NuPath = (Resolve-Path $NuspecFileName)
        [System.IO.File]::WriteAllText($NuPath, $nu, $Utf8NoBomEncoding)
    }
}

if ($MyInvocation.InvocationName -ne '.') { # run the update only if script is not sourced
    update
}
