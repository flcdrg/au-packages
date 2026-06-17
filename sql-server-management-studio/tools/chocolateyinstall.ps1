$ErrorActionPreference = 'Stop';

$fullUrl = 'https://download.visualstudio.microsoft.com/download/pr/a95b7880-2074-4c46-bdbf-e1b8c547ac60/baf7bff250f56f8325503a8e9a66c4ecf6f2b2a456830804c9020ab1c4105a15/vs_SSMS.exe'
$fullChecksum = 'BAF7BFF250F56F8325503A8E9A66C4ECF6F2B2A456830804C9020AB1C4105A15'

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
