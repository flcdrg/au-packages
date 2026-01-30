Import-Module chocolatey-au
#Import-Module D:\git\chocolatey-au\src\Chocolatey-AU.psm1

. ..\_scripts\SqlServerCumulativeUpdates.ps1

function global:au_SearchReplace {
    return SearchReplace 2025 $Latest
}

function global:au_GetLatest {
    return GetLatest 108540 2025
}

function global:au_AfterUpdate ($Package) {

    AfterUpdate $Package $Latest 2025
}

update -ChecksumFor 64
