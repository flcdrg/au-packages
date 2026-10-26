$ErrorActionPreference = 'Stop';

$fullUrl = 'https://download.visualstudio.microsoft.com/download/pr/9a3f23c2-cc94-49a0-88c0-f9f19f2ac9df/d2b54704d52f849360fcbfd96613ab8b5015efd823689972f6ea4b6468e4cbea/vs_SSMS.exe'
$fullChecksum = 'D2B54704D52F849360FCBFD96613AB8B5015EFD823689972F6EA4B6468E4CBEA'

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
