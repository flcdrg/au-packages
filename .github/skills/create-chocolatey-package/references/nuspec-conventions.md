# Nuspec conventions

Repository conventions for `<package>\<package>.nuspec`, with the Chocolatey Community Repository rules that the validator (`chocolatey-community-validation.extension`) enforces at `choco pack`.

## Repository-standard values

| Element | Value |
|---|---|
| `<id>` | lowercase package ID, matching the folder name |
| `<owners>` | `flcdrg` (add co-maintainers separated by `, `) |
| `<packageSourceUrl>` | `https://github.com/flcdrg/au-packages/tree/master/<id>` |
| `<iconUrl>` | `https://cdn.jsdelivr.net/gh/flcdrg/au-packages@master/<id>/icons/<id>.png` |
| `<files>` | `<file src="tools\**" target="tools" />` |
| XML header | `<?xml version="1.0" encoding="utf-8"?>` followed by the generated UTF-8 "Ω" test comment |

Fill `authors` (the software vendor, not the maintainer), `projectUrl`, `licenseUrl`, `copyright` (≥ 4 characters, usually `Copyright © <year> <vendor>`), `tags` (space-separated, lowercase, no commas; include the product name and category), `summary` (one sentence), `description`, and `releaseNotes`. Add `projectSourceUrl`, `docsUrl`, `bugTrackerUrl`, `mailingListUrl` when they exist. Remove elements you cannot populate; never leave template text, placeholders, or e-mail addresses.

## Description

- English, Markdown. Separate paragraphs with blank lines, put a blank line before lists, do not wrap lines mid-sentence. Headings must be `##` or deeper (CPMR0030 rejects `#`).
- Explain what the software does; not just the name and not just a link (CPMR0032). Maximum 4,000 characters (CPMR0026).
- Mention the install location only when it is non-obvious or user-controllable (`Get-ToolsLocation`, unusual or per-user installer paths, or a parameter that changes it); the installer default and Chocolatey's `tools\` directory need no mention.
- For commercial or trial software: licence model, trial length, activation key requirement.
- Document package parameters with `--params` examples (duplicate of `README.md`; keep in sync with `Set-DescriptionFromReadme`).
- `<releaseNotes>` is also Markdown: either the upstream release body (CDATA) or a link to the release page.

## Licence acceptance

Set `<requireLicenseAcceptance>true</requireLicenseAcceptance>` when the vendor EULA must be accepted (commercial, proprietary, or vendor-hosted downloads with click-through terms — 44 packages here do). `true` requires `<licenseUrl>` (CPMR0007). Open-source tools distributed under permissive licences use `false`.

## Dependencies

Declare prerequisites rather than installing them inline:

```xml
<dependencies>
  <dependency id="dotnet-10.0-desktopruntime" />
  <dependency id="vcredist140" version="14.0.24215.1" />
  <dependency id="chocolatey-core.extension" version="1.3.3" />
</dependencies>
```

- Runtimes commonly used in this repository: `dotnet4.6.1`, `netfx-4.7.2`, `dotnet-10.0-desktopruntime`, `vcredist140`, `vcredist2015`, `openjdk`, `PowerShell`.
- `chocolatey-core.extension` provides `Get-AppInstallLocation` and other helpers not built into Chocolatey CLI (`Get-UninstallRegistryKey` and `Get-PackageParameters` are built in and need no dependency); `chocolatey-visualstudio.extension` is used by the Visual Studio extension packages.
- Use `version="x.y.z"` for a minimum, `[x.y.z]` for an exact pin (used by metapackages that track a `.install` package), `[x.y,z.0)` for a range.
- Depending on a `.hook` package is not allowed (CPMR0074).

## Versioned IDs and metapackages

When users keep several major versions installed, publish `<id>-<major>` packages (`sql-server-2019`, `sql-server-2022`, …) and a metapackage `<id>` whose nuspec has only metadata, an empty `<files/>` element, and a dependency on the newest versioned package.

## Validator rules to know

`choco rule` lists every rule the installed extension enforces. Common ones for new packages:

| Rule | Severity | Meaning |
|---|---|---|
| CPMR0001 | Requirement | `copyright` shorter than 4 characters |
| CPMR0002 / CPMR0032 | Requirement | description missing or insufficient |
| CPMR0007 | Requirement | `requireLicenseAcceptance` true without `licenseUrl` |
| CPMR0009 | Requirement | `projectUrl` missing |
| CPMR0014 / CPMR0023 | Requirement | tags comma-separated or absent |
| CPMR0019 | Requirement | template placeholder text left in metadata |
| CPMR0020 | Requirement | e-mail address in metadata |
| CPMR0030 | Requirement | `#` heading in description |
| CPMR0076 | Requirement | `iconUrl` is a `raw.githubusercontent.com` URL |
| CPMR0061 | Note | dots in ID outside recognised suffixes |
| CPMR0068 | Note | `owners` equals `authors` |
| CPMR0069 | Note | long ID without dashes |

Requirements fail `choco pack`; Notes are informational. Full list: <https://docs.chocolatey.org/en-us/community-repository/moderation/package-validator/rules/>.

## Repository examples

| Package | Illustrates |
|---|---|
| `vault` | GitHub release detection, checksum replacement, release notes via `Update-ReleaseNotes` |
| `terrascan` | Archive install with `url`/`url64bit`, `softwareName`, full metadata |
| `tflint` | `-tagPrefix` filtering, semver2→semver1, release notes |
| `ripgrep`, `mergiraf`, `stripe-cli` | Embedded binaries with `Get-RemoteFiles`, `.gitignore`, `LICENSE.txt`/`VERIFICATION.txt` |
| `zoomit` | Version detection by inspecting the downloaded file; `chocolateyBeforeModify.ps1` |
| `consul` | Package parameters, service install, custom uninstall, `.skipAutoUninstall` |
| `azure-pipelines-agent` | README-documented package parameters |
| `microsoft-teams-new-bootstrapper` | Minimum OS check that fails, `.exe.ignore` shim marker |
| `obs-move-transition` | Archive containing an installer: unzip then `Install-ChocolateyInstallPackage` |
| `sql-server-2019` … `sql-server-2025`, `sql-server` | Versioned IDs plus metapackage, `requireLicenseAcceptance`, dependencies |
| `resharper-platform`, `dell-system-update` | VirusTotal submission in `au_AfterUpdate` |
