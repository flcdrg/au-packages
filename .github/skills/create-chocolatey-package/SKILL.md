---
name: create-chocolatey-package
description: "Create or customize a Chocolatey package in this repository for a specified application: nuspec metadata, silent install script, optional uninstall/beforeModify scripts, package parameters, embedded binaries, AU update.ps1 with release notes, icons, and choco pack validation. Use when: creating a new choco package, adding a package folder, writing chocolateyInstall.ps1, writing update.ps1, or packaging an app for Chocolatey."
---

# Create a Chocolatey package

Use this skill when creating a new Chocolatey package in this repository. Work only in the new or explicitly requested package directory; do not modify unrelated packages.

Detailed rules and repository conventions live in the reference files; consult them at the step that needs them:

- [chocolatey-rules.md](./references/chocolatey-rules.md) — pre-flight checks, naming, versioning, encoding, failing on unsupported systems, install paths, icons.
- [nuspec-conventions.md](./references/nuspec-conventions.md) — repository-standard metadata, description rules, dependencies, validator rules, example packages.
- [install-script-patterns.md](./references/install-script-patterns.md) — install/uninstall/beforeModify boilerplate, package parameters, shim markers, `.skipAutoUninstall`.
- [au-update-patterns.md](./references/au-update-patterns.md) — `update.ps1` skeleton, GitHub helpers, `'Ignore'` convention, release notes, embedded binaries, VirusTotal.
- [validation.md](./references/validation.md) — `choco pack` with community validation rules, install test, running AU.

## Gather application details

Identify the package ID and application first. Before anything else, search <https://community.chocolatey.org/packages> (and Repology for open-source tools) so you do not duplicate an existing package and so the ID matches other ecosystems. Research the vendor's official website, download page, documentation, release feed, and license. Use those sources to establish:

- The product's purpose, publisher/authors, latest version, official project and download URLs, documentation, support/issue tracker, and license terms.
- Whether the package downloads an installer/archive at install time or embeds redistributable application files.
- Supported architectures, installer file types, silent-install arguments, install scope, minimum Windows version, and whether the installer registers a usable uninstaller.
- Prerequisites (runtimes, redistributables) that already exist as Chocolatey packages and should become nuspec dependencies.
- Whether the software is commercial or trial (licence model, trial length, activation key), which must be disclosed in the description.
- A dependable upstream source for detecting future versions, and whether the application icon can be extracted from an official asset or executable.

Ask the user for missing information that cannot be verified from authoritative sources, especially the intended package ID, distribution/licensing constraints, architecture or install choices, and any nonstandard install behavior. Do not invent URLs, metadata, versions, checksums, license permissions, or silent switches. If the source or licensing does not permit the proposed packaging method, explain the constraint and ask how to proceed.

## Generate and inspect the template

1. If the requested package directory already exists, skip `choco new` and edit the existing files in place; never overwrite an existing package with freshly generated template output. Otherwise, from the repository root, run `choco new <packagename>` with the agreed package ID (lowercase, hyphen-separated; see naming rules). Review its output and generated paths rather than assuming a particular Chocolatey template version.
2. Keep the package self-contained, following the repository's existing package layout (`<package>\*.nuspec`, `tools\`, optional `icons\`, optional `README.md` for package parameters, and optional `_update.ps1`).
3. Remove template placeholders, sample text, and files that do not apply. In addition to license/verification files when downloading software, remove generated `ReadMe.md` and `_TODO.txt`. Remove `chocolateybeforemodify.ps1` unless a running process or service must be stopped before upgrade/uninstall, and remove the uninstall script for packages that do not install software requiring removal. Do not copy a neighboring package wholesale; use examples only for relevant patterns.
4. Save all `*.nuspec` and `*.ps1` files as UTF-8; new `tools\*.ps1` files must have a BOM. Keep the nuspec XML declaration and UTF-8 test comment.

## Customize package metadata

Update the `.nuspec` with every value that can be verified: `id`, `title`, `version`, `authors`, `owners`, `projectUrl`, `packageSourceUrl`, `tags`, `summary`, `description`, `copyright`, `licenseUrl`, `releaseNotes`, and any applicable `docsUrl`, `bugTrackerUrl`, `projectSourceUrl`, or other supported metadata. Match repository conventions for `owners`, `packageSourceUrl`, the repository-hosted `iconUrl`, and the `<files>` element (see [nuspec-conventions.md](./references/nuspec-conventions.md)). Mirror the upstream version; use SemVer 1 pre-release labels.

Declare runtime prerequisites that already have Chocolatey packages as `<dependencies>` rather than installing them in the script. Write the description as Markdown (English, paragraphs separated by blank lines, `##` or deeper headings), explain what the software does, disclose commercial/trial terms, document any package parameters, and mention the install location only when it is non-obvious or user-controllable (not for the installer default or Chocolatey's `tools\` directory).

Remove optional metadata elements that cannot be accurately populated; never leave template text, fabricated values, or empty placeholders. Keep required nuspec fields valid and ensure the `<files>` list includes the files the package actually ships. Set `requireLicenseAcceptance` according to the actual license (and include `licenseUrl` when it is `true`). Keep descriptions concise, factual, and appropriate for package consumers.

## Implement installation and uninstall

Customize `tools\chocolateyInstall.ps1` for the actual distribution type, following the boilerplate in [install-script-patterns.md](./references/install-script-patterns.md) (`$ErrorActionPreference = 'Stop'`, `$toolsDir`, a `$packageArgs` splat with `packageName = $env:ChocolateyPackageName`, `softwareName`, `validExitCodes`, SHA256 checksums). Always use Chocolatey helper methods for downloading, installing, and extracting; do not replace them with raw download or process-launch logic. Choose the appropriate helper:

- For a vendor installer, use `Install-ChocolateyPackage` for downloads or `Install-ChocolateyInstallPackage` for embedded installers, with documented silent arguments.
- For an archive, use `Install-ChocolateyZipPackage` or `Get-ChocolateyUnzip` as appropriate.
- For a standalone executable or other direct-download portable artifact that does not have an installer, use `Get-ChocolateyWebFile` to download it into the package's `tools\` directory. Chocolatey will shim an executable there onto PATH; do not run the vendor's interactive installer or an application's self-update command as part of package installation.

Use the correct download URL and architecture-specific helper parameters. `Url64bit` only distinguishes 32-bit from 64-bit; when upstream publishes multiple 64-bit builds (for example x64 and ARM64), detect the actual process/native architecture and select the matching URL and checksum explicitly. Fail clearly (`throw`, never only a warning) for unsupported architectures or Windows versions rather than silently installing the wrong binary or reporting success.

If the installer accepts options users will want to change, expose them with `Get-PackageParameters`, document each parameter with `--params` examples in a package `README.md`, and mirror that text in the nuspec description. Use `<name>.exe.ignore` markers to stop Chocolatey shimming installers or helper executables.

Follow this repository's AU convention for version and checksum values: make them replaceable by `au_SearchReplace`, use SHA256 where supported, and retain verified version and checksum values generated by AU in the install script for validation and commit; do not revert them to placeholders. Preserve install idempotency and clean up temporary files when applicable.

Do not add `tools\chocolateyUninstall.ps1` for a standard installer that registers an uninstall entry and can be removed automatically by Chocolatey. Add an uninstall script only when automatic uninstall is unavailable or insufficient, and implement it using Chocolatey helpers and verified application-specific removal behavior; add an empty `tools\.skipAutoUninstall` when the custom script would otherwise run alongside the auto-uninstaller. Add `tools\chocolateyBeforeModify.ps1` only to stop processes or services that would block upgrade or uninstall.

## Handle license and verification files

- For a package that embeds the application files, confirm redistribution is permitted. Complete the generated license and verification files with the applicable license and verifiable source/checksum details; include them in the package. Add a package-level `.gitignore` for the binary file type and use the `au_BeforeUpdate` / `Get-RemoteFiles` pattern so AU refreshes the embedded files (see [au-update-patterns.md](./references/au-update-patterns.md)).
- For a package that downloads the application during installation, delete the generated license and verification files because they are not needed for this distribution model.

Do not embed binaries merely to simplify installation, and do not claim redistribution rights without evidence.

## Add version updates and assets when practical

Create the AU update script when a reliable upstream version source can be identified. **For a new package, name it `_update.ps1`, not `update.ps1`.** The Chocolatey Community Repository must moderate and approve a new package's first version before any further version can be pushed, and the leading underscore makes the daily au-dotnet run skip the package until then; the maintainer renames it to `update.ps1` after approval. The same rename is used to retire automation for deprecated packages or when upstream stops publishing, so never rename an existing `_update.ps1` back without the maintainer's confirmation (see `azure-developer-cli`, `obs-move-transition`). Follow this repository's `chocolatey-au` pattern in [au-update-patterns.md](./references/au-update-patterns.md): import the module, implement the required global AU callbacks (`au_GetLatest`, `au_SearchReplace`, and, when needed, `au_BeforeUpdate`/`au_AfterUpdate`), return the actual latest version and download/checksum values, keep replacements aligned with the install script, convert SemVer 2 pre-release labels to SemVer 1, and finish with `update` (with `-ChecksumFor` when AU should not hash the downloads). Populate `<releaseNotes>` from the upstream release (`Update-ReleaseNotes`) or link to the release page. When the package has a `README.md`, call `Set-DescriptionFromReadme` in `au_AfterUpdate`.

Do not assume the provider's generic "latest release" points to the desired application or artifact: a repository may publish releases for multiple products or extensions, and a pre-release tag may sit ahead of the newest stable one. Filter for the exact stable tag/version convention with a paginated lookup (`Find-GitHubRelease` with a predicate) rather than taking the first prefix match, and verify the release's asset list actually contains every file the install script will download — even when the script builds URLs from the tag rather than from the asset list. When the version, a required asset, or a checksum cannot be found, follow the repository convention: `Write-Warning` with the reason and `return 'Ignore'`, never partial or fabricated update data; wrap every secondary download (checksum manifests and similar) in `try`/`catch` so a transient failure also yields `'Ignore'` instead of failing the AU job. If releases publish a checksum manifest, confirm it is an asset, download it from the asset URL, and parse the exact expected asset filenames, validating that all required hashes were found. Prefer official release APIs/feeds over scraping. Use helpers under `..\_scripts\` where appropriate. If version detection cannot be made dependable, omit the update script rather than creating a misleading or brittle one.

If an application icon can be extracted reliably from an official asset or the application itself, save a PNG (at least 128 px, transparent background, the icon rather than the logo) in the package's `icons\` directory and reference its jsDelivr URL in the nuspec. Do not use unrelated assets or add an icon that cannot be verified.

## Validate and report

Follow [validation.md](./references/validation.md):

1. Static review for leftover template values, correct package ID/version/URLs, valid nuspec XML, appropriate Chocolatey helper and install behavior, correct license-file treatment, UTF-8 BOM on new scripts, and consistency between AU replacements and installer variables. For architecture-specific code, verify the selected URL and checksum for every supported architecture and ensure unsupported architectures fail clearly.
2. Run `choco pack` in the package directory and inspect the resulting package contents for generated files that should not ship. The installed `chocolatey-community-validation.extension` applies Community Repository rules during pack: fix every Requirement failure (do not remove legitimate metadata just to satisfy a rule), address Guidelines where practical, and report remaining Notes.
3. When safe and not excluded by the user, install from the packed output with `choco install <id> --source <dir> --yes` (passing `--params` if documented) and uninstall again, checking the Chocolatey log.
4. Run `.\_update.ps1` (the `chocolatey-au` module is installed locally and in CI) when `au_GetLatest` queries an official vendor API/feed over HTTPS and the user has not asked you to avoid network access; review the resulting diff to the nuspec and install script and keep the generated values. Then load the callbacks in isolation and drive each `'Ignore'` branch (missing release, missing asset, failed or malformed manifest) with overridden helpers, as shown in the reference. If the module cannot be imported, do not install dependencies for this check; use the same isolation technique and state that the AU workflow was not executed.

Summarize the created package files, install/uninstall and distribution decisions, version-update support (and that `_update.ps1` must be renamed to `update.ps1` after moderation approval), validator output, and validation performed. Call out any unresolved information or verification that could not be completed.

## Repository examples

- `vault\` — GitHub-release version detection, AU checksum replacements, release notes.
- `terrascan\` — nuspec metadata and architecture-specific archive installation.
- `zoomit\` — version detection by inspecting the downloaded application; `chocolateyBeforeModify.ps1`.
- `ripgrep\`, `mergiraf\` — embedded binaries with `Get-RemoteFiles`, `.gitignore`, `LICENSE.txt`/`VERIFICATION.txt`.
- `consul\`, `azure-pipelines-agent\` — package parameters documented in `README.md`; custom uninstall with `.skipAutoUninstall`.
- `microsoft-teams-new-bootstrapper\` — minimum OS check that fails, `.exe.ignore` shim marker.
- More in [nuspec-conventions.md](./references/nuspec-conventions.md#repository-examples).
- `.github\copilot-instructions.md` — repository architecture, AU callbacks, checksum, testing, and metadata conventions.
