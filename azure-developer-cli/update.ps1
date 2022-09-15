import-module au

function global:au_SearchReplace {
    @{
        'tools\chocolateyInstall.ps1' = @{
            "(^\`$url\s*=\s*)('.*')"    = "`$1'$($Latest.Url32)'"
            "(^\`$checksum\s*=\s*)('.*')"   = "`$1'$($Latest.Checksum32)'"
        }
    }
}

. ../_scripts/GitHub.ps1

function global:au_GetLatest {
    # This repo has releases for the cli tool as well as VS Code vsix
    $release = Get-GitHubLatestRelease "Azure/azure-dev" "azure-dev-cli"
    
    $version = Get-ReleaseVersion -release $release -prefix "azure-dev-cli_"

    # Convert semver2 to semver1
    $version = $version.Replace("-beta.", "-beta")

    if (-not $version) {
        Write-Warning "Couldn't find version number"
        return "Ignore"
    }

    $assets = Get-GitHubReleaseAssets $release

    $asset32 = $assets | Where-Object { $_.name -eq "azd-windows-amd64.zip" }

    $Latest = @{
        Url32 = $asset32.browser_download_url
        Version = $version
        ReleaseNotes = $release.body.Replace("# ", "## ") # Increase heading levels
    }
    return $Latest
}

function global:au_AfterUpdate ($Package) {
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

update