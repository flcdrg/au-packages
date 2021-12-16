# BeyondCompare Integration

Chocolatey package for configuring Beyond Compare with version control and other tools

[![Chocolatey](https://img.shields.io/chocolatey/v/beyondcompare-integration.svg?maxAge=2592000)](https://chocolatey.org/packages/beyondcompare-integration)

This package uses the chocolateyinstall.ps1 script to configure all matching applications to use Beyond Compare as the default file comparison tool.

## Applications supported

* Git for Windows
* Tortoise Git
* Tortoise SVN

Pull requests most welcome for adding support for other applications. See [Using Beyond Compare with Version Control Systems](http://www.scootersoftware.com/support.php?zz=kb_vcs) for documentation on configuring Beyond Compare with other version control systems.

## Approach

1. Feature detection is used to identify which applications are currently installed.
2. If the application uses a config file, a backup is taken and the path to the backup file is logged as a warning.
3. If the application uses the registry, then the existing values are logged as warnings.
4. The config for the application is updated.
