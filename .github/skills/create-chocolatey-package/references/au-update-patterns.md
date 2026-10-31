# AU update script patterns

How `update.ps1` scripts in this repository are written. The module is the `flcdrg/chocolatey-au` fork (`simplify` branch), installed as `Chocolatey-AU`; CI installs the same fork (`.github\workflows\ci.yml`). Repository-wide conventions are in `.github\copilot-instructions.md`.

## Disabling automation: `_update.ps1`

The daily au-dotnet run only picks up scripts named `update.ps1`. Renaming the script to **`_update.ps1`** keeps it in the repository for reference or later reactivation while taking the package out of the automatic run. The maintainer uses this in three situations:

- **New package** — the Community Repository must approve a brand-new package's first version through moderation before any later version can be pushed, so always create the script as `_update.ps1` and rename it after approval.
- **Deprecated package** — the package is superseded or retired and must not receive new versions.
- **Upstream stopped publishing** — the vendor no longer releases updates or the version source has gone away.

Everything below applies to the file under either name, and you run it locally as `.\_update.ps1`. Examples: `azure-developer-cli`, `obs-move-transition`, `ozcode`, `iguana`. When editing an existing package, do not rename `_update.ps1` back to `update.ps1` without confirming with the maintainer which case applies.

## Skeleton

```powershell
Import-Module chocolatey-au
. ../_scripts/GitHub.ps1        # only when using the GitHub helpers

function global:au_SearchReplace {
    @{
        'tools\chocolateyInstall.ps1' = @{
            "(^\s*url\s*=\s*)('.*')"        = "`$1'$($Latest.Url32)'"
            "(^\s*url64bit\s*=\s*)('.*')"   = "`$1'$($Latest.Url64)'"
            "(^\s*checksum\s*=\s*)('.*')"   = "`$1'$($Latest.Checksum32)'"
            "(^\s*checksum64\s*=\s*)('.*')" = "`$1'$($Latest.Checksum64)'"
        }
    }
}

function global:au_GetLatest {
    $release = Get-GitHubLatestRelease 'owner/repo'
    $version = Get-ReleaseVersion -release $release -prefix 'v'
    # Convert semver2 to semver1
    $version = $version.Replace('-beta.', '-beta').Replace('-rc.', '-rc')

    if (-not $version) {
        Write-Warning "Couldn't find version number"
        return 'Ignore'
    }

    $assets = Get-GitHubReleaseAssets $release
    $asset32 = $assets | Where-Object { $_.name -eq 'tool_windows_386.zip' }
    $asset64 = $assets | Where-Object { $_.name -eq 'tool_windows_amd64.zip' }

    if (-not $asset32 -or -not $asset64) {
        Write-Warning "Couldn't find expected release assets"
        return 'Ignore'
    }

    @{
        Version      = $version
        Url32        = $asset32.browser_download_url
        Url64        = $asset64.browser_download_url
        ReleaseNotes = $release.body.Replace('# ', '## ')
    }
}

function global:au_AfterUpdate ($Package) {
    Update-ReleaseNotes $Package
}

update
```

Each regex must match the *exact* assignment line in the install script (`$packageArgs` key or `$variable = '...'`). Keys in `$Latest` other than `Version`, `Url32`/`Url64`, `Checksum32`/`Checksum64`, `ChecksumType32/64`, `FileName32/64`, `ReleaseNotes`, `PackageName` are free-form and available to `au_SearchReplace` and `au_AfterUpdate`.

## When the latest version cannot be determined

Return `'Ignore'` after a `Write-Warning`; do not throw and do not return partial data. AU skips the package and the daily run continues (`vault`, `tflint`, `ripgrep`, `mergiraf`, `sealed-secrets`, `terrascan`). Use this for: no matching release, missing architecture asset, missing entry in a checksum manifest, or an unparsable version.

Every secondary fetch after the release lookup (checksum manifests, version files, redirect probes) must be wrapped in `try { … } catch { Write-Warning …; return 'Ignore' }` — an unhandled exception from `Invoke-RestMethod`/`Invoke-WebRequest` fails the whole AU job rather than skipping the package.

## Release assets

- Verify the release actually carries every file the install script will download, even when the install script builds URLs from the tag and fixed file names rather than from the asset list: a manifest entry or a predictable URL is not proof the binary was uploaded. Compare `Get-GitHubReleaseAssets` names against the required set and `Ignore` on any gap (`waza`).
- When a release publishes a checksum manifest (`checksums.txt`, `SHA256SUMS`), confirm it is in the asset list, download it from the asset's `browser_download_url`, match each required file name exactly (`(?m)^([a-fA-F0-9]{64})\s+<file>\s*$`), and `Ignore` if any hash is missing.
- `Invoke-RestMethod` returns a JSON array as a single object. Consume helper output through the pipeline (`$assets | Where-Object …`, or `@(Get-GitHubReleaseAssets $release | ForEach-Object { $_ })`) — wrapping the call directly in `@()` nests the array and makes `Where-Object` return the whole list.

## GitHub helpers (`_scripts\GitHub.ps1`)

- `Get-GitHubLatestRelease 'owner/repo'` — the release GitHub marks *latest*.
- `Get-GitHubLatestRelease 'owner/repo' -tagPrefix 'cli-v'` — newest release whose tag starts with the prefix; use when a repository publishes several products (`tflint`, `vault` comment).
- `Get-GitHubLatestRelease 'owner/repo' -newest` — most recent release regardless of the *latest* flag (includes pre-releases).
- `Find-GitHubRelease 'owner/repo' { <predicate on $_> } [maxPages]` — pages through releases (100 per page, default 5 pages) and returns the first one matching the predicate, or `$null`. Use it when the first prefix match may be a pre-release or another product's tag, e.g. `{ -not $_.prerelease -and $_.tag_name -match '^v\d+\.\d+\.\d+$' }` (`waza`).
- `Get-ReleaseVersion -release $r [-prefix 'v']` — strips the prefix from `name`/`tag_name`; returns `$null` if neither matches.
- `Get-GitHubReleaseAssets $r` — up to 100 assets (the default release object only carries the first page).
- `Update-ReleaseNotes $Package` — writes `$Latest.ReleaseNotes` into a CDATA `<releaseNotes>` after `<description>`; call from `au_AfterUpdate`.
- Authentication uses `$env:github_api_key` when set (CI provides the Actions token).

Non-GitHub sources: use `Invoke-RestMethod` against the vendor's official feed/API (`mergiraf` uses the Codeberg API; `PDFXchangeEditor` parses an XML feed). Scrape HTML only as a last resort. `Get-RedirectedUri` in `_scripts\common.ps1` resolves a stable "latest" URL to the versioned file.

## Release notes

Either:

- `$Latest.ReleaseNotes = $release.body…` plus `Update-ReleaseNotes $Package` in `au_AfterUpdate` (full Markdown body; `tflint`, `vault`), or
- `$Latest.ReleaseNotes = "https://…/releases/tag/$($release.tag_name)"` plus an `au_SearchReplace` entry on the nuspec: `"<package>.nuspec" = @{ "(?i)(<releaseNotes>).*?(</releaseNotes>)" = "`$1$($Latest.ReleaseNotes)`$2" }` (`mergiraf`).

## README → description

If the package has a `README.md` (package parameters), keep the nuspec description in sync automatically:

```powershell
. ../_scripts/Set-DescriptionFromReadme.ps1

function global:au_AfterUpdate ($Package) {
    Set-DescriptionFromReadme -SkipFirst 2   # skip the H1 and blank line
}
```

## `update` switches

- `update` — default; AU downloads `Url32`/`Url64` and computes SHA256 into `Checksum32`/`Checksum64`.
- `update -ChecksumFor none` — no download/hash: use when the vendor publishes checksums you read in `au_GetLatest`, when the files are embedded (`au_BeforeUpdate` already downloaded them), or when the URL is not versioned.
- `update -ChecksumFor 32` / `64` — only one architecture exists.
- `update -NoReadme` — do not touch README-derived content.

## Embedded binaries

Use only when redistribution is permitted (see `LICENSE.txt`). Pattern (`ripgrep`, `mergiraf`, `stripe-cli`, `sealed-secrets`, `consul`):

```powershell
function global:au_BeforeUpdate() {
    Get-RemoteFiles -Purge -NoSuffix   # downloads Url32/Url64 into tools\, sets $Latest.FileName32/64
}

function global:au_SearchReplace {
    @{
        '.\tools\chocolateyInstall.ps1' = @{
            "(?i)(^\s*FileFullPath\s*=\s*)(.*)"   = "`$1Join-Path `$toolsDir '$($Latest.FileName32)'"
            "(?i)(^\s*FileFullPath64\s*=\s*)(.*)" = "`$1Join-Path `$toolsDir '$($Latest.FileName64)'"
        }
    }
}
# …
update -ChecksumFor none
```

- `-Purge` deletes previously downloaded files; `-NoSuffix` keeps the original file name (omit it to get `_x32`/`_x64` suffixes).
- To ship only an extracted executable, `Expand-Archive` in `au_BeforeUpdate` and delete the archive (`stripe-cli`, `mergiraf`).
- Add a package-level `.gitignore` for the binary type (`*.zip`, `tools/*.exe`, `*.tar.gz`) so binaries are never committed; CI downloads them during the run.
- Ship `tools\LICENSE.txt` (verbatim upstream licence) and `tools\VERIFICATION.txt` describing where to download the file and how to compare `Get-FileHash` output (`stripe-cli\tools\VERIFICATION.txt`).
- Install with `Get-ChocolateyUnzip` (`FileFullPath`/`FileFullPath64`) or `Install-ChocolateyInstallPackage` (`file`/`file64`).

## VirusTotal (optional)

For vendor binaries that are not already scanned, submit the downloaded file after an update:

```powershell
. ../_scripts/Submit-VirusTotal.ps1

function global:au_AfterUpdate ($Package) {
    VirusTotal_AfterUpdate $Package
}
```

Requires `vt-cli` on `PATH` and `$env:VT_APIKEY`; the helper warns and skips when the key is unset (`resharper-platform`, `dell-system-update`, `ubiquiti-unifi-controller`).

## Running the update locally

```powershell
cd <package>
.\_update.ps1                      # detect and apply a newer version (.\update.ps1 once approved and renamed)
$au_Force = $true; .\_update.ps1   # re-run replacements even when the version is unchanged
```

Review the resulting diff to the nuspec and install script before committing. `update_vars.ps1` (gitignored) can set `$env:github_api_key`/`$env:VT_APIKEY` locally.
