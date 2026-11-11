$ErrorActionPreference = 'Stop';

$fullUrl = 'https://download.visualstudio.microsoft.com/download/pr/4aa37a90-1dc9-4507-9e7b-49134341b6c4/740dc34296300addbdd65d216f33bd29eba0584f6704fc478116626687151c87/vs_SSMS.exe'
$fullChecksum = '740DC34296300ADDBDD65D216F33BD29EBA0584F6704FC478116626687151C87'

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
