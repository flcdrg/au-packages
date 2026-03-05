#Import-Module chocolatey-au
Import-Module "$PSScriptRoot\..\..\chocolatey-au\src\chocolatey-au.psd1"

. ..\_scripts\SqlServerCumulativeUpdates.ps1

function global:au_SearchReplace {
    return SearchReplace 2017 $Latest
}

function global:au_GetLatest {
    return GetLatest 56128 2017
}

function global:au_AfterUpdate ($Package) {

    AfterUpdate $Package $Latest 2017
}

update -ChecksumFor 64
