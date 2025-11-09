# Chocolatey packages

[![Chocolatey Profile](https://img.shields.io/badge/Chocolatey_Profile-flcdrg-yellowgreen)](https://chocolatey.org/profiles/flcdrg)
[![Update Status](https://img.shields.io/badge/Update-Status-blue.svg)](https://gist.github.com/flcdrg/7d00c69c2cde8309a8594abaa897a9a6)

This repository contains my Chocolatey packages. Where possible I use [chocolatey automatic packages](https://chocolatey.org/docs/automatic-packages). These packages will have an `update.ps1` script in the folder that is run daily to automatically detect and publish new versions.

If there is no `update.ps1`, I haven't got around to creating one yet.

Do you use these packages? [Show your appreciation by sponsoring me!](https://github.com/sponsors/flcdrg)

## Contributions

If you have found a bug or have a suggestion, please feel free to raise an issue.

Pull requests are also most welcome!

## Prerequisites

To run locally you will need:

- Powershell 7+.
- [Custom fork of Chocolatey AU](https://github.com/flcdrg/chocolatey-au/tree/simplify) (has some extra features that hopefully will be merged into Chocolatey AU eventually)
- [au-dotnet](https://github.com/flcdrg/au-dotnet/), a custom orchestrator used instead of the AU module's `update_all.ps1` script (to work around issues with PowerShell 7+).

## Automatic package update

### Single package

Run from within the directory of the package to update that package:

```powershell
    cd <package_dir>
    ./update.ps1
```

If this script is missing, the package is not automatic.  
Set `$au_Force = $true` prior to script call to update the package even if no new version is found.
