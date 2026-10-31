
# global
$headers = @{}

<#
.SYNOPSIS
    Get the info for the latest release

.PARAMETER project
    GitHub project path (used to create URL for API)

.PARAMETER tagPrefix
    Prefix for the tag name

.PARAMETER newest
    Set to true to just get the most recent release (not necessarily one marked 'latest')

.OUTPUTS
    Output (if any)

#>
function Initialize-GitHubHeaders {
    $token = $env:github_api_key
    $script:headers = @{
        'User-Agent' = 'flcdrg'
    }
    if ($token) {
        $script:headers['Authorization'] = ("token {0}" -f $token)
    } else {
        Write-Warning "No auth token"
    }
}

function Get-GitHubLatestRelease($project, $tagPrefix, [switch] $newest) {

    Initialize-GitHubHeaders

    $releasesUrl = "https://api.github.com/repos/$project/releases"

    if ($newest.IsPresent) {
        $releases = Invoke-RestMethod -Method Get -Uri "$releasesUrl" -Headers $script:headers
        $releases | Select-Object -First 1
    }
    elseif ($tagPrefix) {
        $releases = Invoke-RestMethod -Method Get -Uri "$releasesUrl" -Headers $script:headers
        $releases | Where-Object { $_.tag_name -and $_.tag_name.StartsWith($tagPrefix) } | Select-Object -First 1

    } else {
        Invoke-RestMethod -Method Get -Uri "$releasesUrl/latest" -Headers $script:headers
    }
}

<#
.SYNOPSIS
    Find the most recent release that satisfies a predicate, paging through the release list

.PARAMETER project
    GitHub project path (used to create URL for API)

.PARAMETER predicate
    Script block evaluated against each release ($_); the first release for which it returns true is returned

.PARAMETER maxPages
    Maximum number of 100-item pages to scan before giving up (default 5)

.OUTPUTS
    The matching release, or $null if none was found within maxPages

.EXAMPLE
    Find-GitHubRelease 'microsoft/waza' { -not $_.prerelease -and $_.tag_name -match '^v\d+\.\d+\.\d+$' }
#>
function Find-GitHubRelease($project, [scriptblock] $predicate, [int] $maxPages = 5) {

    Initialize-GitHubHeaders

    $releasesUrl = "https://api.github.com/repos/$project/releases"

    for ($page = 1; $page -le $maxPages; $page++) {
        $releases = Invoke-RestMethod -Method Get -Uri "${releasesUrl}?per_page=100&page=$page" -Headers $script:headers
        if (-not $releases) {
            return $null
        }

        $match = $releases | Where-Object $predicate | Select-Object -First 1
        if ($match) {
            return $match
        }
    }

    return $null
}

function Get-GitHubReleaseAssets($release) {
    Invoke-RestMethod -Method Get -Uri "$($release.assets_url)?per_page=100" -Headers $script:headers
}

function Get-GitHubReleaseAssetsBrowserDownloadUrls($assets) {
    Invoke-RestMethod -Method Get -Uri $assets[0].browser_download_url -Headers $script:headers
}

function Get-ReleaseVersion($release, [string] $prefix) {
    if ($prefix) {
        if ($release.name -and $release.name.StartsWith($prefix)) {
            $release.name.Substring($prefix.Length)
        } elseif ($release.tag_name -and $release.tag_name.StartsWith($prefix)) {
            $release.tag_name.Substring($prefix.Length)
        } else {
            return $null
        }
    # Prefer tag_name
    } elseif ($release.tag_name) {
        $release.tag_name
    } elseif ($release.name) {
        $release.name
    }
}

function Update-ReleaseNotes($Package) {
    [System.Xml.XmlNamespaceManager]$xmlNsManager = New-Object System.Xml.XmlNamespaceManager($Package.NuspecXml.NameTable)
    [void]$xmlNsManager.AddNamespace("ns", $Package.NuspecXml.package.GetAttribute("xmlns"))

    # If 'releaseNotes' is a string property (no CDATA child) then we need to remove it so we can replace it with
    # a proper Element that has a child CDATA.
    $releaseNotesNode = $Package.NuspecXml.package.metadata.SelectSingleNode("ns:releaseNotes", $xmlNsManager)
    if ($releaseNotesNode) {
        [void]$Package.NuspecXml.package.metadata.RemoveChild($releaseNotesNode)
    }
    # Create releaseNotes element
    $releaseNotesNode = $Package.NuspecXml.CreateElement("releaseNotes", $Package.NuspecXml.DocumentElement.NamespaceURI)
    $cdataNode = $Package.NuspecXml.CreateCDataSection($Latest.ReleaseNotes)
    [void] $releaseNotesNode.AppendChild($cdataNode)

    # Insert releaseNotes after description
    $descriptionNode = $Package.NuspecXml.package.metadata.SelectSingleNode("ns:description", $xmlNsManager)
    [void] $Package.NuspecXml.package.metadata.InsertAfter($releaseNotesNode, $descriptionNode)
    $Package.SaveNuspec()
}