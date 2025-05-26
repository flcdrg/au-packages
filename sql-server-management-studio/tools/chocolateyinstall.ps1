$ErrorActionPreference = 'Stop';

Install-VisualStudio `
    -PackageName 'sql-server-management-studio' `
    -ApplicationName 'SQL Server Management Studio' `
    -Url 'https://download.visualstudio.microsoft.com/download/pr/8d215e6a-7f65-4949-bc09-e1befa5b6497/e16b5eda7e6eecad858faa89cabb3fd5f6b108b70f2fa18eb38fbbe3d679dd3d/vs_SSMS.exe' <# https://aka.ms/ssms/21/release/vs_SSMS.exe #> `
    -Checksum 'E16B5EDA7E6EECAD858FAA89CABB3FD5F6B108B70F2FA18EB38FBBE3D679DD3D' `
    -ChecksumType 'SHA256' `
    -InstallerTechnology 'WillowVS2017OrLater' `
    -DefaultParameterValues @{
      channelId = 'SSMS.21.SSMS.Release'
      channelUri = 'https://aka.ms/ssms/21/release/channel'
    }
