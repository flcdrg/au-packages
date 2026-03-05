# AI contributor guide for this repo

This repository maintains ~100 Chocolatey packages using automatic AU-style update scripts. Each package auto-detects upstream version changes and publishes updates daily via au-dotnet orchestration.

## Architecture & Core Pattern

**Multi-tier package structure:**
- **Package folder** (e.g., `vault/`, `PDFXchangeEditor/`): Completely self-contained (icons, README, tools, metadata).
  - `update.ps1` — AU-driven version detection; defines three global callbacks.
  - `tools/chocolateyInstall.ps1` — handles download+install; variables injected by update.ps1.
  - `*.nuspec` — package metadata (name, version, description from README.md).
  - `tools/chocolateyUninstall.ps1` (optional) — removal logic.
  - `README.md` (when needed) — documents installer `--params` flags; used to populate nuspec description.

**Helper ecosystem** (`_scripts/`):
- `GitHub.ps1` — GitHub Releases API helpers (`Get-GitHubLatestRelease`, `Get-ReleaseVersion`, `Update-ReleaseNotes`).
- `Set-DescriptionFromReadme.ps1` — syncs README.md → nuspec description in `au_AfterUpdate`.
- `common.ps1` — utility functions (e.g., `Get-RedirectedUri` for tracking download redirects).
- `Submit-VirusTotal.ps1`, `Get-MSIInfo.ps1`, `SqlServerCumulativeUpdates.ps1` — specialized helpers for complex packages.

## AU Update Script Pattern

Standard `update.ps1` structure (uses chocolatey-au fork):

```powershell
Import-Module chocolatey-au
# . ../_scripts/GitHub.ps1  # if using GitHub helpers

function global:au_GetLatest {
    # 1. Fetch latest version (REST API, web scraping, GitHub, etc.)
    # 2. Return $Latest = @{ Version='x.y.z'; Checksum32='...'; Url='...'; Url64='...'; ... }
}

function global:au_SearchReplace {
    # 3. Define regex replacements to inject Latest values into tools/chocolateyInstall.ps1
    @{ 'tools\chocolateyInstall.ps1' = @{ "pattern" = "replacement"; ... } }
}

function global:au_AfterUpdate ($Package) {
    # 4. Optional post-update hooks (e.g., Set-DescriptionFromReadme)
}

update  # Kick-off the AU workflow
```

Key global variables AU provides: `$Latest` (latest version info), `$Package` (nuspec XML object), `$ChecksumType` (SHA256 default).

## Developer Workflows

**Single package update** (for testing or manual override):
```powershell
cd vault
./update.ps1                    # Auto-detect and update
$au_Force = $true; ./update.ps1 # Force update even if version unchanged
```

**Batch updates** (primary workflow on PS7+):
- Use `au-dotnet` orchestrator (https://github.com/flcdrg/au-dotnet/), NOT `update_all.ps1`.
- au-dotnet coordinates updates across all packages, respects filters, publishes status to public gist.

**Testing changes locally:**
- `choco pack` in a package folder to build the .nupkg.
- `choco install -s . <package>` to test locally with `--params` if documented in README.

## Critical Conventions

1. **Version detection**: Prefer GitHub Releases API (with `GitHub.ps1` helpers) → fallback to direct REST API → last resort web scraping.
2. **Checksum injection**: Always use `au_SearchReplace` to replace hardcoded checksums in `tools/chocolateyInstall.ps1`. Never commit real checksums; AU regenerates them.
3. **README → nuspec sync**: If package accepts installer `--params` (e.g., `azure-pipelines-agent`, `sql-server-2019`), document in `README.md` and call `Set-DescriptionFromReadme -SkipFirst N` in `au_AfterUpdate`.
4. **Idempotent installs**: `chocolateyInstall.ps1` must handle re-runs gracefully (check if already installed, clean temp files, etc.).
5. **Asset isolation**: All package files (icons, screenshots) live in package folder; never pollute root or other packages.

## Pattern Examples by Complexity

- **GitHub Releases (simple)**: `vault/update.ps1` — fetch latest release, extract version, inject checksums.
- **Version transformation**: `PDFXchangeEditor/update.ps1` — parse XML tracker feed, convert semver2 → semver1, extract x32/x64 URLs separately.
- **File introspection**: `zoomit/update.ps1` — download ZIP, extract .exe, read file version info, no remote API.
- **Conditional detection**: `tflint/update.ps1` — use GitHub API with tag prefix filter, custom release notes formatting.

## External Dependencies

- **Custom AU fork** (https://github.com/flcdrg/chocolatey-au/tree/simplify): Provides `Import-Module chocolatey-au`, `$Latest`, callback hooks, `update` function.
- **Orchestrator** (https://github.com/flcdrg/au-dotnet/): Runs batch updates on schedule, publishes status gist.
- **Chocolatey**: `choco pack` (build), `choco install -s .` (test); end-users pass `--params` from package READMEs.
- **GitHub API** (optional): Used for releases tracking; auth via `$env:github_api_key` for rate-limiting.

## AI Editing Guidelines

- **Modifying `update.ps1`**: Preserve AU callback function names (`global:au_GetLatest`, `global:au_SearchReplace`, `global:au_AfterUpdate`), respect `$Latest` object shape, keep `update` call at end.
- **New package**: Create folder, add `update.ps1` (or skip if manual), `tools/chocolateyInstall.ps1`, `*.nuspec`, and `README.md` (if `--params` exist). Use existing packages as templates.
- **Regex in `au_SearchReplace`**: Must match variable assignment in `tools/chocolateyInstall.ps1` exactly (e.g., `(^\s*\$checksum\s*=\s*)('.*')`); test locally with `./update.ps1`.
- **No secrets in repo**: Use `$env:*` variables or `.gitignore`-d `update_vars.ps1` for local API keys, credentials.
- **Description sync**: Always call `Set-DescriptionFromReadme` if README.md exists to keep nuspec description in sync.
