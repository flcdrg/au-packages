$ErrorActionPreference = 'Stop';

$fullUrl = 'https://download.visualstudio.microsoft.com/download/pr/e98d75fa-91b1-47a1-9cb7-b6556de592c5/81245bc868b13cb2f60b6976109e550af7fb853943d5bb1e5c27578f09395c6d/vs_SSMS.exe'
$fullChecksum = '81245BC868B13CB2F60B6976109E550AF7FB853943D5BB1E5C27578F09395C6D'

Install-VisualStudio `
    -PackageName 'sql-server-management-studio' `
    -ApplicationName 'SQL Server Management Studio' `
    -Url $fullUrl `
    -Checksum $fullChecksum `
    -ChecksumType 'SHA256' `
    -InstallerTechnology 'WillowVS2017OrLater' `
    -DefaultParameterValues @{
      channelId = 'SSMS.21.SSMS.Release'
      channelUri = 'https://aka.ms/ssms/21/release/channel'
    } `
    -Product 'ssms'
