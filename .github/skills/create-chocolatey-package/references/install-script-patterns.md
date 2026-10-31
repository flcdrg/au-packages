# Install and uninstall script patterns

Conventions used by the `tools\chocolateyInstall.ps1`, `tools\chocolateyUninstall.ps1`, and `tools\chocolateyBeforeModify.ps1` scripts in this repository. Helper reference: <https://docs.chocolatey.org/en-us/create/functions/>.

## Install script boilerplate

Every install script starts with:

```powershell
$ErrorActionPreference = 'Stop'
$toolsDir = "$(Split-Path -Parent $MyInvocation.MyCommand.Definition)"
```

Build a `$packageArgs` hashtable and splat it into exactly one Chocolatey helper. Keep each AU-replaced value on its own line as a simple assignment so `au_SearchReplace` can target it (`url`, `url64bit`, `checksum`, `checksum64`, or a `$checksum` variable).

| Distribution | Helper | Example |
|---|---|---|
| Vendor installer downloaded at install time | `Install-ChocolateyPackage` | `pingplotter` |
| Installer shipped inside the package or extracted from an archive | `Install-ChocolateyInstallPackage` with `file`/`file64` | `obs-move-transition` |
| Archive extracted into `tools\` or `Get-ToolsLocation` | `Install-ChocolateyZipPackage` | `terrascan`, `consul` |
| Archive shipped inside the package | `Get-ChocolateyUnzip` with `FileFullPath`/`FileFullPath64` | `ripgrep` |
| Single portable executable | `Get-ChocolateyWebFile` into `tools\` | `vt-cli` |

Keys to set:

- `packageName = $env:ChocolateyPackageName` — never hard-code the ID.
- `softwareName` — the Programs and Features display name with a trailing `*` (`'PingPlotter*'`). Required for `Install-ChocolateyPackage`/`Install-ChocolateyInstallPackage` so upgrades and Chocolatey's auto-uninstaller can locate the entry.
- `fileType` — `exe`, `msi`, or `msu`.
- `silentArgs` — verified from vendor documentation. Common values: MSI `/qn /norestart`; Inno Setup `/VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-`; NSIS `/S`; InstallShield `/s /v"/qn"`. Do not guess.
- `validExitCodes` — `@(0)` for most installers, `@(0, 3010, 1641)` for MSI (3010/1641 = reboot required).
- `checksum`/`checksum64` with `checksumType = 'sha256'` (`checksumType64` when both architectures exist). Keep the SHA256 values AU generates; do not revert them to placeholders.
- `url64bit` only distinguishes 32- and 64-bit x86. For ARM64 or other 64-bit variants, pick the URL and checksum explicitly from `$env:PROCESSOR_ARCHITECTURE` / `[System.Runtime.InteropServices.RuntimeInformation]::OSArchitecture` and `throw` for unsupported architectures.

For an archive that contains an installer, extract with `Install-ChocolateyZipPackage` first and then run `Install-ChocolateyInstallPackage` on the extracted file (`obs-move-transition`). Clean up large extracted files after a successful install when they are no longer needed.

## Package parameters

Use `Get-PackageParameters` (32 packages do, for example `azure-pipelines-agent`, `consul`, `dotCover`, `sql-server-2022`):

```powershell
$pp = Get-PackageParameters

$silentArgs = '/qn /norestart'
if ($pp['InstallDir']) { $silentArgs += " INSTALLDIR=`"$($pp['InstallDir'])`"" }
if ($pp['NoDesktopShortcut']) { $silentArgs += ' DESKTOP_SHORTCUT=0' }
```

- Parameter names use `/Name:value` (or `/Flag` for booleans); users pass them with `--params "'/Name:value /Flag'"`.
- Document every parameter, its default, and at least one full `choco install … --params` example in the package `README.md`, and mirror that text in the nuspec `<description>` (see `azure-pipelines-agent\README.md`). Mention `choco feature enable -n=useRememberedArgumentsForUpgrades` when parameters matter for upgrades.
- Keep README and nuspec in sync by calling `Set-DescriptionFromReadme` in `au_AfterUpdate` (see [au-update-patterns.md](./au-update-patterns.md)).

## Failing clearly

Check prerequisites before downloading anything and fail with `throw`/`Write-Error`, never `Write-Warning` alone:

```powershell
$minimumOsVersion = [version]'10.0.19041'
$osVersion = [version](Get-CimInstance Win32_OperatingSystem).Version
if ($osVersion -lt $minimumOsVersion) {
    throw "$env:ChocolateyPackageName requires Windows 10 build $minimumOsVersion or later. Detected $osVersion."
}
```

## Shim control

Chocolatey creates a shim for every `.exe` under the package directory. Control this with empty marker files next to the executable (exact, case-sensitive name):

- `<name>.exe.ignore` — do not shim (installers, helper binaries). Examples: `obs-move-transition\tools\move-transition-installer.exe.ignore`, `microsoft-teams-new-bootstrapper\tools\teamsbootstrapper.exe.ignore`.
- `<name>.exe.gui` — shim as a GUI application so the console does not wait.

When the executable is downloaded or extracted at install time, create the marker in the install script (`New-Item "$exePath.ignore" -ItemType File -Force | Out-Null`) rather than committing it, unless the file name is stable.

## Uninstall

Do **not** add `chocolateyUninstall.ps1` for a standard MSI/EXE installer that registers a Programs and Features entry; Chocolatey's auto-uninstaller handles it using `softwareName`. `Install-ChocolateyZipPackage` also removes extracted files automatically.

Add `chocolateyUninstall.ps1` only when removal needs more than the registered uninstaller: stopping and deleting services, removing scheduled tasks or environment variables, cleaning data directories, or when the vendor uninstaller needs non-standard arguments (`consul`, `sql-server-*`, `iguana.install`). Use helpers:

```powershell
$ErrorActionPreference = 'Stop'
[array]$key = Get-UninstallRegistryKey -SoftwareName 'Product Name*'

if ($key.Count -eq 1) {
    $key | ForEach-Object {
        $packageArgs = @{
            packageName    = $env:ChocolateyPackageName
            fileType       = 'exe'
            silentArgs     = '/S'
            validExitCodes = @(0)
            file           = "$($_.UninstallString)"
        }
        Uninstall-ChocolateyPackage @packageArgs
    }
} elseif ($key.Count -eq 0) {
    Write-Warning "$env:ChocolateyPackageName has already been uninstalled by other means."
} else {
    Write-Warning "$($key.Count) matches found! Please alert the package maintainer."
    $key | ForEach-Object { Write-Warning "- $($_.DisplayName)" }
}
```

When a custom uninstall script is present *and* the auto-uninstaller would also find the registry entry, add an empty `tools\.skipAutoUninstall` file so Chocolatey does not run both (14 packages, for example `consul`, `sql-server-2022`, `sql-server-management-studio`).

## Before-modify script

`chocolateyBeforeModify.ps1` runs from the installed version before an upgrade or uninstall. Add it only when something must be stopped first; keep it minimal and tolerant:

```powershell
Get-Process ZoomIt, ZoomIt64 -ErrorAction SilentlyContinue | Stop-Process
```

Examples: `zoomit`, `consul` (stop service), `azure-pipelines-agent` (stop `vstsagent*` services unless `/NoStopService`). Remove the generated template file when nothing needs stopping.

## Idempotency

Install scripts run on install *and* upgrade, and may be re-run after a failure. Remove stale extracted files before re-extracting, tolerate an already-registered service or existing directories, and never prompt for input.
