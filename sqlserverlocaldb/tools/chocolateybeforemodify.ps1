$sqlLocalDb = 'C:\Program Files\Microsoft SQL Server\110\Tools\Binn\SqlLocalDB.exe'

if (Test-Path $sqlLocalDb) {
    & $sqlLocalDb stop
}