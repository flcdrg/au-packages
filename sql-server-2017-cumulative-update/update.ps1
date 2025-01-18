Import-Module chocolatey-au

. ..\_scripts\SqlServerCumulativeUpdates.ps1

function global:au_SearchReplace {
    return SearchReplace 2022 $Latest
}

function global:au_GetLatest {
    return GetLatest 56128 2017
}

function global:au_AfterUpdate ($Package) {

    AfterUpdate $Package $Latest 2017
}

update -ChecksumFor 64
