$ErrorActionPreference = 'Stop';

$fullUrl = 'https://download.visualstudio.microsoft.com/download/pr/af2bf19c-59e9-48c4-bac6-019f173389ac/67aaad913cd31f95ffd6535af7d157a807b6715ad221082cea170117d289c695/vs_SSMS.exe'
$fullChecksum = '67AAAD913CD31F95FFD6535AF7D157A807B6715AD221082CEA170117D289C695'

Install-VisualStudio `
  -PackageName 'sql-server-management-studio' `
  -ApplicationName 'SQL Server Management Studio' `
  -Url $fullUrl `
  -Checksum $fullChecksum `
  -ChecksumType 'SHA256' `
  -InstallerTechnology 'WillowVS2017OrLater' `
  -DefaultParameterValues @{
  channelId  = 'SSMS.22.SSMS.Release'
  channelUri = 'https://aka.ms/ssms/22/release/channel'
} `
  -Product 'Ssms'
