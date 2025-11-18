$ErrorActionPreference = 'Stop';

$fullUrl = 'https://download.visualstudio.microsoft.com/download/pr/d3b4e0f6-4bc0-4ec0-ba9c-20b355d61cc4/41b0ec8225d7d6a773abc363b0fb90a9443072e49fa4619271220e244b11f832/vs_SSMS.exe'
$fullChecksum = '41B0EC8225D7D6A773ABC363B0FB90A9443072E49FA4619271220E244B11F832'

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
