Import-Module chocolatey-au

. ..\_scripts\SqlServerCumulativeUpdates.ps1

function global:au_SearchReplace {
    return SearchReplace 2019 $Latest
}

function global:au_GetLatest {
    return GetLatest 100809 2019
}

function global:au_AfterUpdate ($Package) {

    AfterUpdate $Package $Latest 2019
}

update -ChecksumFor 64
