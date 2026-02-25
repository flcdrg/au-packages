$ErrorActionPreference = 'Stop';

$fullUrl = 'https://download.visualstudio.microsoft.com/download/pr/2b23517b-e100-42e1-a560-063af6edc4ec/11afc06e10a3e19ec60f9ca7b768ed68b9a74d8fcff5f6acac275127ba60c965/vs_SSMS.exe'
$fullChecksum = '11AFC06E10A3E19EC60F9CA7B768ED68B9A74D8FCFF5F6ACAC275127BA60C965'

Install-VisualStudio `
    -PackageName 'sql-server-management-studio' `
    -ApplicationName 'SQL Server Management Studio' `
    -Url $fullUrl `
    -Checksum $fullChecksum `
    -ChecksumType 'SHA256' `
    -InstallerTechnology 'WillowVS2017OrLater' `
    -DefaultParameterValues @{
      channelId = 'SSMS.22.SSMS.Release'
      channelUri = 'https://aka.ms/ssms/22/release/channel'
    } `
    -Product 'ssms'
