$ErrorActionPreference = 'Stop';

$fullUrl = 'https://download.visualstudio.microsoft.com/download/pr/c7f9c40d-5956-4fa0-bd04-b866c2461198/58efa2590bf79fcea84f35cb6d0c5f6b852f7aa21a8e40939d1fdfe9cba80650/vs_SSMS.exe'
$fullChecksum = '58EFA2590BF79FCEA84F35CB6D0C5F6B852F7AA21A8E40939D1FDFE9CBA80650'

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
