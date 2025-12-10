$ErrorActionPreference = 'Stop';

$fullUrl = 'https://download.visualstudio.microsoft.com/download/pr/451b234a-4e25-491d-a007-bf3e55b2562f/c3a2c8139d0f7d0f49eee056c03aac30de6d7dc0477dc2d631569be8661436b9/vs_SSMS.exe'
$fullChecksum = 'C3A2C8139D0F7D0F49EEE056C03AAC30DE6D7DC0477DC2D631569BE8661436B9'

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
