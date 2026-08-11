$ErrorActionPreference = 'Stop';

$fullUrl = 'https://download.visualstudio.microsoft.com/download/pr/b1ea2f6c-5e55-49bc-81e8-7623cc5a6743/69916e21ce9a9e865a58e6b61cc93e7572a58a1b4382eba7ab26ebb01d71ee0e/vs_SSMS.exe'
$fullChecksum = '69916E21CE9A9E865A58E6B61CC93E7572A58A1B4382EBA7AB26EBB01D71EE0E'

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
