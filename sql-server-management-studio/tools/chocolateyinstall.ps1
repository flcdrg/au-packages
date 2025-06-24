$ErrorActionPreference = 'Stop';

$fullUrl = 'https://download.visualstudio.microsoft.com/download/pr/13907dbe-8bb3-4cfe-b0ae-147e70f8b2f3/65c818b45c9e80b6bfa5156819eabc01e1340a92d1b8693949661f7af1a46c6d/vs_SSMS.exe'
$fullChecksum = '65C818B45C9E80B6BFA5156819EABC01E1340A92D1B8693949661F7AF1A46C6D'

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
