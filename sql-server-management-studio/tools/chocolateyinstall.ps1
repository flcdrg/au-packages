$ErrorActionPreference = 'Stop';

$fullUrl = 'https://download.visualstudio.microsoft.com/download/pr/c2e2845d-bdff-44fc-ac00-3d488e9f5675/6f664a1b1ebfce23ed412d9a392b6fc5fcab2f623d6ad8259baa192388565231/vs_SSMS.exe'
$fullChecksum = '6F664A1B1EBFCE23ED412D9A392B6FC5FCAB2F623D6AD8259BAA192388565231'

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
