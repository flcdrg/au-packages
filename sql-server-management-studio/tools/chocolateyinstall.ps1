$ErrorActionPreference = 'Stop';

$fullUrl = 'https://download.visualstudio.microsoft.com/download/pr/c40d2503-2e56-4f54-96c2-d886056cfedb/7b7e3d2c029a74af8ba86a2e6fe1cdabecb39732ad041f6d25d15bf89f2913a4/vs_SSMS.exe'
$fullChecksum = '7B7E3D2C029A74AF8BA86A2E6FE1CDABECB39732AD041F6D25D15BF89F2913A4'

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
