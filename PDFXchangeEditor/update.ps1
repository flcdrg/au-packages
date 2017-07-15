import-module au

function ParseReleaseNotes($html)
{
    $ul = $html.getElementById("bh-history");

    # summary
    $ul.children[0].children[0].innerText;
    ""

    # version from <a class="active" name="6.0.317.1" href="PDFXE_history.html#6.0.317.1">
    $version = $ul.children[0].children[0].name

    # 
    $subUl = $html.getElementById("changes-$version").children[0]

    $newlyAdded = New-Object System.Collections.ArrayList
    $bugFixed = New-Object System.Collections.ArrayList
    $changed = New-Object System.Collections.ArrayList

    $allowedTags = @('#text', 'a')

    foreach ($child in $subUl.children)
    {
        
        $type = $child.children[0].title

        # remove unwanted tags
        [void] ($child.childNodes | Where-Object { $allowedTags -notcontains $_.nodeName } | % { $child.removeChild($_) } )

        # convert links

        [void] ($child.childNodes | Where-Object { $_.nodeName -eq 'A' } | % { 
                $textNode = $ie.Document.createTextNode("[$($_.innerText)]($($_.href))")
                $child.replaceChild($textNode, $_)
            } 
            
        )

        $value = ($child.innerHTML.Trim().Replace("&lt;", "<").Replace("&gt;", ">").Replace("&amp;", "&") )

        switch ($type) 
        {
            "Newly added feature" 
            {
                [void] $newlyAdded.Add($value)
            }
            "A reported error or bug was fixed" 
            {
                [void] $bugFixed.Add($value)
            }
            "Changed, reviewed, modified feature" 
            {
                [void] $changed.Add($value)
            }
        }
    }

    if ($newlyAdded)
    {
        "#### Newly added feature"
        ""
        $newlyAdded | % { "* " + $_ }
        ""
    }

    if ($bugFixed)
    {
        "#### A reported error or bug was fixed"
        ""
        $bugFixed | % { "* " + $_ }
        ""
    }

    if ($changed) 
    {
        "#### Changed, reviewed, modified feature"
        ""

        $changed | % { "* " + $_ }
    }
}

function global:au_SearchReplace {
    @{
        'tools\chocolateyInstall.ps1' = @{
            "(^[$]checksum\s*=\s*)('.*')" = "`$1'$($Latest.Checksum32)'"
            "(^[$]checksum64\s*=\s*)('.*')" = "`$1'$($Latest.Checksum64)'"
        }
     }
}

function global:au_GetLatest {

    try {
        $response = Invoke-RestMethod -Uri "https://www.tracker-software.com/trackerupdate/TrackerData.xml"

        # Unfortunately, they're include a Byte Order Mark, so we have to trim that off
        $xml = [xml] $response.Substring(3)

        $xmlNameSpace = new-object System.Xml.XmlNamespaceManager($xml.NameTable)
        $xmlNameSpace.AddNamespace("t", "http://schemas.tracker-software.com/trackerupdate/tb/v1")

        $pdfxeditorNode = $xml.SelectSingleNode("//t:bundle[@id='PDFXEditor']", $xmlNameSpace)

        $Latest = @{ 
            Version = $pdfxeditorNode.update[0].version
            Checksum32 = $pdfxeditorNode.SelectSingleNode("./t:update[@platform='x32']", $xmlNameSpace).hash
            Checksum64 = $pdfxeditorNode.SelectSingleNode("./t:update[@platform='x64']", $xmlNameSpace).hash
            ReleaseNotes = ""
        }
    }
    catch {
        $Latest = @{}
        Write-Error $_
    }
    return $Latest
}


function global:au_AfterUpdate
{ 
    $nuspecFileName = $Latest.PackageName + ".nuspec"
    $nu = gc $nuspecFileName -Raw -Encoding UTF8
    $nu = $nu -replace "(?smi)(\<releaseNotes\>).*?(\</releaseNotes\>)", "`${1}$($Latest.ReleaseNotes)`$2"

    $Utf8NoBomEncoding = New-Object System.Text.UTF8Encoding($False)
    $NuPath = (Resolve-Path $NuspecFileName)
    [System.IO.File]::WriteAllText($NuPath, $nu, $Utf8NoBomEncoding)
}

update -ChecksumFor none