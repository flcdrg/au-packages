$ErrorActionPreference = 'Stop';

$fullUrl = 'https://download.visualstudio.microsoft.com/download/pr/105ab965-3bff-41cb-a75d-b4020a784328/1497c1f0da4ebe4ddf8fa89c8d53f13bbe0fc0fa19e2971bb54d0dd48853de81/vs_SSMS.exe'
$fullChecksum = '1497C1F0DA4EBE4DDF8FA89C8D53F13BBE0FC0FA19E2971BB54D0DD48853DE81'

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
