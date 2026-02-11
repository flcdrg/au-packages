$ErrorActionPreference = 'Stop';

$fullUrl = 'https://download.visualstudio.microsoft.com/download/pr/50e56d52-cb9f-4891-880e-59ab5de5c80d/4627c205d11769e7d4acc67b2b69363ca02dcc6caa051e7dae65e1cfc40de961/vs_SSMS.exe'
$fullChecksum = '4627C205D11769E7D4ACC67B2B69363CA02DCC6CAA051E7DAE65E1CFC40DE961'

Install-VisualStudio `
    -PackageName 'sql-server-management-studio' `
    -ApplicationName 'SQL Server Management Studio' `
    -Url $fullUrl `
    -Checksum $fullChecksum `
    -ChecksumType 'SHA256' `
    -InstallerTechnology 'WillowVS2017OrLater' `
    -DefaultParameterValues @{
      channelId = 'SSMS.22.SSMS.Release'
      channelUri = 'https://aka.ms/ssms/22/release/channel'
    } `
    -Product 'ssms'
