Remove-VisualStudioProduct `
    -PackageName 'sql-server-management-studio' `
    -Product 'Ssms' `
    -VisualStudioYear '2026' `
    -Preview $false `
    -DefaultParameterValues @{
      channelId = 'SSMS.22.SSMS.Release'
      channelUri = 'https://aka.ms/ssms/22/release/channel'
    }
