$ErrorActionPreference = 'Stop';

$fullUrl = 'https://download.visualstudio.microsoft.com/download/pr/df8b8a1d-60a9-4872-99a4-7b1bcd00b219/6f3653dd0e2e36e87b21da7bdee3d3e67020a9b94684a6fd23678448bfcb0e4f/vs_SSMS.exe'
$fullChecksum = '6F3653DD0E2E36E87B21DA7BDEE3D3E67020A9B94684A6FD23678448BFCB0E4F'

Install-VisualStudio `
    -PackageName 'sql-server-management-studio' `
    -ApplicationName 'SQL Server Management Studio' `
    -Url $fullUrl `
    -Checksum $fullChecksum `
    -ChecksumType 'SHA256' `
    -InstallerTechnology 'WillowVS2017OrLater' `
    -DefaultParameterValues @{
      channelId = 'SSMS.21.SSMS.Release'
      channelUri = 'https://aka.ms/ssms/21/release/channel'
    } `
    -Product 'ssms'
