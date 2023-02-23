import-module au

function global:au_SearchReplace {
    @{ }
}

. ../_scripts/GitHub.ps1

function global:au_BeforeUpdate() {
    Get-RemoteFiles -Purge -NoSuffix
}

function global:au_GetLatest {
    # This repo has releases for the cli tool as well as VS Code vsix
    $release = Get-GitHubLatestRelease "hashicorp/consul"

    $version = Get-ReleaseVersion -release $release -prefix "v"

    # Convert semver2 to semver1
    $version = $version.Replace("-beta.", "-beta").Replace("-rc.", "-rc")

    if (-not $version) {
        Write-Warning "Couldn't find version number"
        return "Ignore"
    }

    $Latest = @{
        Version = $version
        Url32 = "https://releases.hashicorp.com/consul/$version/consul_$($version)_windows_386.zip"
        Url64 = "https://releases.hashicorp.com/consul/$version/consul_$($version)_windows_amd64.zip"
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