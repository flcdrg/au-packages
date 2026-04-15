$ErrorActionPreference = 'Stop';

$fullUrl = 'https://download.visualstudio.microsoft.com/download/pr/7b660e19-415f-4c6c-bc8a-6a0b524cc688/8e631da57acebdd79ace817c4bafd83c1dd213dee0142d38e67d03461fd4662c/vs_SSMS.exe'
$fullChecksum = '8E631DA57ACEBDD79ACE817C4BAFD83C1DD213DEE0142D38E67D03461FD4662C'

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
