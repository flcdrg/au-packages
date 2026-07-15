$ErrorActionPreference = 'Stop';

$fullUrl = 'https://download.visualstudio.microsoft.com/download/pr/e05c0bc8-d058-4b2b-937c-1c80073d7633/58e51d839f2f9b5e5ddf96b365ce591d6fcdc9f050b2767fb6a8e5f185178ac5/vs_SSMS.exe'
$fullChecksum = '58E51D839F2F9B5E5DDF96B365CE591D6FCDC9F050B2767FB6A8E5F185178AC5'

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
