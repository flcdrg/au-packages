$ErrorActionPreference = 'Stop';

$fullUrl = 'https://download.visualstudio.microsoft.com/download/pr/f55fba7b-3f02-49b7-9aca-a075049a807d/c2d75555c4674948771dd1bb9433103560dbf7ad7bccb1d822818e7af59494cc/vs_SSMS.exe'
$fullChecksum = 'C2D75555C4674948771DD1BB9433103560DBF7AD7BCCB1D822818E7AF59494CC'

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
