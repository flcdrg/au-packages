# Chocolatey packaging rules

Distilled from <https://docs.chocolatey.org/en-us/create/create-packages/> and adapted to this repository. Read before creating a package.

## Before creating a package

- Search <https://community.chocolatey.org/packages> first. If a package already exists, improve it (PR to its maintainer) rather than creating a duplicate.
- For open-source software, check <https://repology.org/> and reuse the package ID other ecosystems use.
- Do not bundle prerequisites (runtimes, redistributables, other tools) that already have a Chocolatey package; declare them as nuspec `<dependencies>` instead.
- Split optional modules, plug-ins, or language files into separate `parent-feature` packages.
- Do not package software you have no right to redistribute; download from the official location at install time instead. Never package illegal software, software bundling adware/spyware, or junk.
- Commercial or trial software must say so in the description: licence model, whether an activation key is required, and the trial length.

## Naming

- `<id>` is lowercase. Replace spaces with `-`; do not introduce dots unless the product name has one (for example `paint.net`) or the suffix is one of the recognised `.install`, `.portable`, `.extension`, `.template`, `.hook`. CamelCase names simply become lowercase (`virtualbox`).
- Sub-packages use a hyphen: `keepass-langfiles`, `obs-ndi`, `keepass-rpc`.
- `<title>` is the official product name with its correct casing and spaces (`Interfaceware Iguana`, `ReSharper`).
- Never put `chocolatey` in the ID; `choco` is allowed only with "Unofficial" in the title.
- When users need different major versions installed side by side, create versioned IDs plus a metapackage that depends on the newest one. Repository example: `sql-server-2017`, `sql-server-2019`, `sql-server-2022`, `sql-server-2025` with `sql-server` as the metapackage; `ozcode-vs2017` / `ozcode-vs2022`.

## Versioning

- Mirror the upstream version exactly, using the same number of segments (1–4).
- Chocolatey CLI only understands SemVer 1 pre-release labels: convert `1.2.0-beta.3` to `1.2.0-beta3` and `-rc.1` to `-rc1` (see `tflint\update.ps1`, `mergiraf\update.ps1`).
- The fourth segment is reserved for *package fix notation* when the software version has not changed but the package needs fixing: use `yyyyMMdd` (for example `1.2.0.20240922`). If upstream already uses four segments, append `00` and increment (`2.0.0.35300` → `2.0.0.35301`), and keep that extra pair for every later fix of the same version.
- Prefer the stable release. Pre-releases may be published under the same ID with a `-` pre-release suffix.

## Character encoding

- Save every `*.nuspec` and `*.ps1` as UTF-8. New `tools\*.ps1` files **must** be UTF-8 with BOM so Windows PowerShell reads non-ASCII characters correctly.
- Keep the nuspec XML declaration `<?xml version="1.0" encoding="utf-8"?>` and the generated `<!-- Do not remove this test for UTF-8: if "Ω" doesn't appear … -->` comment.
- Create new PowerShell files with `[System.IO.File]::WriteAllText($path, $content, [System.Text.UTF8Encoding]::new($true))` or an editor configured for UTF-8 BOM; verify with `Get-Content -AsByteStream -TotalCount 3` (`239 187 191`). These commands are for your PowerShell 7 session (`-AsByteStream` is `-Encoding Byte` on 5.1); the package scripts themselves must stay 5.1-compatible.

## Unsupported OS or architecture must fail

An installed package signals success, so a warning is not acceptable when the software cannot be installed. Check the Windows version or architecture and `throw` (or `Write-Error` with `$ErrorActionPreference = 'Stop'`) with a clear message. Repository example: `microsoft-teams-new-bootstrapper\tools\chocolateyinstall.ps1` compares `(Get-CimInstance Win32_OperatingSystem).Version` with the minimum build. The only exception is a low-level dependency package that legitimately has nothing to do on some Windows versions.

## Installation paths

Choose one:

1. The installer's own default path (`Program Files`). Use when the vendor installer is used.
2. The package `tools\` directory (`%ChocolateyInstall%\lib\<id>\tools`). Executables placed there are shimmed onto `PATH` automatically. Use for portable archives and single executables.
3. `Get-ToolsLocation` (`%ChocolateyToolsLocation%`, default `C:\tools`) when the user should be able to relocate a portable application. Use `Install-ChocolateyZipPackage -UnzipLocation (Join-Path (Get-ToolsLocation) '<id>')`.

Options 1 and 2 are the Chocolatey defaults and need no mention in the description. Mention the location only when it is non-obvious or user-controllable: option 3 (name the `%ChocolateyToolsLocation%` override), an installer that installs somewhere unusual or per-user, or a package parameter / `--install-arguments` value that changes the directory (document how to pass it).

## Elevated shell environment variables

Chocolatey runs elevated. When a standard user elevates with an administrator's credentials, `APPDATA`, `LOCALAPPDATA`, `TEMP`, `TMP`, `USERNAME`, and `USERPROFILE` belong to the administrator account, not the logged-in user. Avoid per-user install locations; if the installer only supports per-user installs, state this clearly in the description.

## Icons

- Use the application's *icon* (not its logo), PNG, at least 128 px, transparent background, extracted from the official executable or an official asset. Do not upscale small icons or use favicons.
- Store it at `<package>\icons\<package>.png` and reference it through jsDelivr using the repository convention:
  `https://cdn.jsdelivr.net/gh/flcdrg/au-packages@master/<package>/icons/<package>.png`.
  (Chocolatey docs recommend a tag/commit-pinned CDN URL; this repository standardises on `@master`.)
- Never hotlink vendor sites and never use `raw.githubusercontent.com` (validator rule CPMR0076 rejects it).

## Miscellaneous

- Do not create a folder named `content` inside the package; NuGet treats it specially.
- `chocolateyBeforeModify.ps1` runs from the *currently installed* version before upgrade or uninstall. Add it only to stop running processes or services that would block replacement (`zoomit`, `consul`); otherwise do not ship it.
- Keep PowerShell constructs compatible with Windows PowerShell 5.1 (Chocolatey CLI does not run install scripts under PowerShell 7).
