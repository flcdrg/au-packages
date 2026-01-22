$ErrorActionPreference = 'Stop';

$fullUrl = 'https://download.visualstudio.microsoft.com/download/pr/98009c04-e4b8-4223-8794-58f961de75a4/fa1ff5d20743db1e6fc7732c1593ed427c25d1d34d887cfb2c24a8bca38ce83b/vs_SSMS.exe'
$fullChecksum = 'FA1FF5D20743DB1E6FC7732C1593ED427C25D1D34D887CFB2C24A8BCA38CE83B'

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
