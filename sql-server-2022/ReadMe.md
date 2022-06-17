# Description

SQL Server 2022 Preview is the most Azure-enabled release of SQL Server yet, with continued innovation in security, availability, and performance.

### Overview

SQL Server 2022 Preview integrates with Azure Synapse Link and Azure Purview to enable customers to drive deeper insights, predictions, and governance from their data at scale. Cloud integration is enhanced with disaster recovery to Azure SQL Managed Instance, along with no-ETL connections to cloud analytics, which allow database administrators to manage their data estates with greater flexibility and minimal impact to the end-user. Performance and scalability are automatically enhanced via built-in query intelligence. There is choice and flexibility across languages and platforms, including Linux, Windows, and Kubernetes.

- Business continuity through Azure
- Seamless analytics over on-prem operational data
- Visibility over your entire data estate
- Most secure over the last 10 years
- Industry-leading performance and availability

### Operating System requirements for SQL Server Developer

- Windows 10 TH1 1507 or greater
- Windows Server 2016 or greater

### Package Specific

#### Package notes

This package will install SQL Server 2022 Developer Edition using an existing .iso file. If a path to an existing .iso is not supplied, it downloads the same .iso that can be obtained from the [SQL Server Basic Installer](https://go.microsoft.com/fwlink/?linkid=2162123&clcid=0x409&culture=en-us&country=us)'s *Download Media* menu.

#### Package Parameters

The following package parameters can be set:

- `/IsoPath:` - path to a local copy of the .iso file - if not supplied then .iso is downloaded
- `/IgnorePendingReboot` - don't check for pending reboot (Warning, SQL Server installation may fail if reboots are pending)

All other package parameters are passed through to SQL Server Setup, allowing you to customise the installation as necessary.

The following are set by default:

- `/ConfigurationFile:` - The path to a configurationfile.ini - defaults to the supplied tools\configurationfile.ini
- `/SQLSYSADMINACCOUNTS:` - A username or group to add to the SQL SysAdmin role - defaults to current user. This option is only set if configurationfile.ini does not contain 'SQLSYSADMINACCOUNTS=' at the start of a line.

See https://docs.microsoft.com/en-us/sql/database-engine/install-windows/install-sql-server-from-the-command-prompt#Install for the full list of parameters supported by SQL Server.

To pass parameters, use `--params "''"` (e.g. `choco install sql-server-2022 [other options] --params="'/ITEM:value /ITEM2:value2'"`).

Example using /IsoPath to use previously downloaded SQL Server .iso

```powershell
choco install sql-server-2022 --params="'/IsoPath:c:\downloads\SQLServer2022-x64-ENU-Dev.iso'"
```

#### Chocolatey Pro / Business users

If you allow the package to download the ISO file, it is suggested you run Chocolatey with the `--skip-virus-check` parameter, as the online virus scanner doesn't handle files over 500MB. You should use alternate methods of scanning in this case.
