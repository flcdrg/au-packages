# dotnetup

dotnetup is a cross-platform toolchain manager for user-level .NET SDK and runtime installations. This package installs the dotnetup command-line executable for Windows x64 and Arm64.

## Per-user installation

The executable is installed in `%USERPROFILE%\.dotnetup`, a writable directory required by dotnetup's self-update coordination. The package adds this directory to the installing account's user PATH. Open a new terminal after installation.

This package is not an all-users installation. Run Chocolatey with your own account; if you elevate using another administrator's credentials, dotnetup is installed for that administrator instead. Use the same account for upgrades and uninstall.

dotnetup is in public preview. The package installs the executable but does not run its interactive setup. Run `dotnetup init` to configure managed .NET installations. On Windows, the default setup mode changes the system PATH and requires elevation; choose the `none` or `shell` mode to avoid those system-wide changes.

Uninstall removes the executable and its user PATH entry. Managed SDKs, runtimes, dotnetup data, and manually configured .NET environment settings are preserved. To remove those as well, follow Microsoft's [removal instructions](https://learn.microsoft.com/en-us/dotnet/core/tools/dotnetup/usecases/manage-dotnetup#remove-dotnetup) before uninstalling this package.
