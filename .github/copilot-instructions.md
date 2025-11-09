# AI contributor guide for this repo

This repository hosts many Chocolatey packages. Packages are maintained with AU-style `update.ps1` scripts, but batch orchestration is handled with a separate tool (see below). The goal is to keep package folders consistent and automate updates safely.

## Big picture

- Structure: Each package lives in its own folder at the repo root (e.g., `windows-admin-center/`). Typical contents:
  - `<pkg>.nuspec` (metadata), `tools/chocolateyinstall.ps1`, optionally `tools/chocolateyuninstall.ps1`.
  - `update.ps1` (AU script) for automatic packages; packages without it are manual.
  - A package-specific `README.md` when parameters or special notes exist.
- Automation: A custom fork of Chocolatey AU is used for updater helpers inside each package, while a separate orchestrator (au-dotnet) drives batch updates across packages.
- CI/status: Update status is published to a public gist (see badge in `README.md`). CI details may change; prefer running locally with PowerShell 7+.

## Developer workflows

- Prerequisites:
  - PowerShell 7+ and Chocolatey installed.
  - Custom AU fork: https://github.com/flcdrg/chocolatey-au/tree/simplify (used by per‑package scripts).
  - Orchestrator: https://github.com/flcdrg/au-dotnet/ (used instead of AU’s `update_all.ps1`).

- Single package update (automatic packages):
  - From the package directory, run `./update.ps1`.
  - Set `$au_Force = $true` before the call to force an update even if no new version is detected.

- Batch update:
  - Use the au-dotnet orchestrator to run updates across packages on PowerShell 7+. Refer to its documentation for commands and filters.
  - The legacy `update_all.ps1` exists but is not the primary path on PS7; avoid relying on it unless specifically intended.

-- Optional test runs: Some legacy scripts (e.g., `test_all.ps1`) remain for local validation; prefer au-dotnet for coordinated runs.

## Conventions and patterns

- Keep all package assets within the package folder (icons, screenshots, config files).
- Prefer automatic packages when feasible; include `update.ps1` using AU patterns.
- Use AU’s standard variables and callbacks within each `update.ps1`. Many packages use the conventional AU update script with 1–2 custom lines to locate the latest release or version.
- Package READMEs document user-facing parameters. See examples:
  - `azure-pipelines-agent/README.md` for supported `--params` flags.
  - `sql-server-2019/README.md` for package-specific install details and OS requirements.
- For nuspec descriptions, Markdown is allowed in `<description>` blocks and used widely.

## Key files and directories

- Root scripts:
  - `_scripts/` — helper PowerShell scripts; `all.ps1` dot-sources others in this folder.
- Package anatomy:
  - `*/update.ps1` — the AU script present in most automatic packages.
  - `*/tools/chocolateyinstall.ps1` — installation steps; may call upstream installers or unpack zips.
  - `*/README.md` — parameters and package-specific notes when relevant.

## External dependencies and integration

- Custom AU fork (helpers for per‑package scripts): https://github.com/flcdrg/chocolatey-au/tree/simplify
- Orchestrator for batch runs: https://github.com/flcdrg/au-dotnet/
- Chocolatey: building (`choco pack`) and installing/testing; end users pass `--params` as documented in per-package READMEs.
- Gist/GitHub: update status is published to a gist (see badge in the root `README.md`).

## Tips for AI changes

- When editing a package:
  - Update only that package’s folder; don’t spill assets into the root or other packages.
  - If altering `update.ps1`, keep AU patterns intact (respect `$global:au_*` vars and the repo’s PS7/au-dotnet orchestration assumptions).
  - Reflect user-facing changes in the package `README.md` and nuspec `<description>`.
- When adding a new package:
  - Follow the structure above and reference AU’s “Creating the package updater script”.
  - If the package is manual (no `update.ps1`), omit AU hooks and ensure `tools/chocolateyinstall.ps1` is robust and idempotent.
- Don’t commit secrets. Keep local secrets out of the repo; prefer environment variables or local `update_vars.ps1` ignored by git.

## Examples in this repo

- Parameters-heavy package: `azure-pipelines-agent/README.md` enumerates many `/Param:` options and how to pass them.
- Non-standard purpose package: `azure-functions-core-tools` only submits binaries to VirusTotal; its README clarifies this.
- Complex installer: `sql-server-2019/README.md` shows how large installers and ISO mounting are handled and how parameters are forwarded.

If any of these sections are unclear or if other workflows exist (e.g., GitHub Actions, local test harnesses), let me know and I’ll refine this guide.
