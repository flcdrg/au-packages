$ErrorActionPreference = 'Stop';

$fullUrl = 'https://download.visualstudio.microsoft.com/download/pr/e07fb79d-d4ec-45bc-b19d-200bc819ee8d/845b7431296e6d3e0e10eca264becd0541452f26e0abb99fdc3a4bfb53d75dad/vs_SSMS.exe'
$fullChecksum = '845B7431296E6D3E0E10ECA264BECD0541452F26E0ABB99FDC3A4BFB53D75DAD'

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
