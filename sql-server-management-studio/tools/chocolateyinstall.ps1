$ErrorActionPreference = 'Stop';

$fullUrl = 'https://download.visualstudio.microsoft.com/download/pr/fe4fb3e6-ea32-4ae3-b154-72821a274f0d/c1f09479f2ae491c057620a3f7a4fcebb815988e99c4825565b928511037f20e/vs_SSMS.exe'
$fullChecksum = 'C1F09479F2AE491C057620A3F7A4FCEBB815988E99C4825565B928511037F20E'

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
