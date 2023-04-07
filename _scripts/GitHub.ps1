
# global
$headers = @{}

<#
.SYNOPSIS
    Get the info for the latest release

.PARAMETER project
    GitHub project path (used to create URL for API)

.OUTPUTS
    Output (if any)

#>
function Get-GitHubLatestRelease($project, $tagPrefix) {

    $token = $env:github_api_key
    $script:headers = @{
        'User-Agent' = 'flcdrg'
    }
    if ($token) {
        $script:headers['Authorization'] = ("token {0}" -f $token)
    } else {
        Write-Warning "No auth token"
    }

    $releasesUrl = "https://api.github.com/repos/$project/releases"

    if ($tagPrefix) {
        $releases = Invoke-RestMethod -Method Get -Uri "$releasesUrl" -Headers $headers
        $releases | Where-Object { $_.tag_name -and $_.tag_name.StartsWith($tagPrefix) } | Select-Object -First 1

    } else {
        Invoke-RestMethod -Method Get -Uri "$releasesUrl/latest" -Headers $headers
    }
}

function Get-GitHubReleaseAssets($release) {
    Invoke-RestMethod -Method Get -Uri $release.assets_url -Headers $script:headers
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
    $xmlNsManager.AddNamespace("ns", $Package.NuspecXml.package.GetAttribute("xmlns"))

    # If 'releaseNotes' is a string property (no CDATA child) then we need to remove it so we can replace it with
    # a proper Element that has a child CDATA.
    $releaseNotesNode = $Package.NuspecXml.package.metadata.SelectSingleNode("ns:releaseNotes", $xmlNsManager)
    if ($releaseNotesNode) {
        $Package.NuspecXml.package.metadata.RemoveChild($releaseNotesNode)
    }
    # Create releaseNotes element
    $releaseNotesNode = $Package.NuspecXml.CreateElement("releaseNotes", $Package.NuspecXml.DocumentElement.NamespaceURI)
    $cdataNode = $Package.NuspecXml.CreateCDataSection($Latest.ReleaseNotes)
    $releaseNotesNode.AppendChild($cdataNode)

    # Insert releaseNotes after description
    $descriptionNode = $Package.NuspecXml.package.metadata.SelectSingleNode("ns:description", $xmlNsManager)
    $Package.NuspecXml.package.metadata.InsertAfter($releaseNotesNode, $descriptionNode)
    $Package.SaveNuspec()
}