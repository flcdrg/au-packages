Remove-VisualStudioProduct `
    -PackageName 'sql-server-management-studio' `
    -Product 'Ssms' `
    -VisualStudioYear '2022' `
    -Preview $false `
    -DefaultParameterValues @{
      channelId = 'SSMS.21.SSMS.Release'
      channelUri = 'https://aka.ms/ssms/21/release/channel'
    }
