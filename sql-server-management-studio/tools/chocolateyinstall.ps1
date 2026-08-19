$ErrorActionPreference = 'Stop';

$fullUrl = 'https://download.visualstudio.microsoft.com/download/pr/7834fc97-5a8c-4392-a2a9-ed4b98f77180/11dd68bbeb84cf17ff062c2cb3f1200ce6c4811782e7672e96a9a6e48c4a5157/vs_SSMS.exe'
$fullChecksum = '11DD68BBEB84CF17FF062C2CB3F1200CE6C4811782E7672E96A9A6E48C4A5157'

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
