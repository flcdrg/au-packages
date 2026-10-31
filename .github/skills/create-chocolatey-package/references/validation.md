# Validating a package

Local prerequisites match the CI `Install` step in `.github\workflows\ci.yml`:

```powershell
choco install chocolatey-community-validation.extension vt-cli -y
Import-Module chocolatey-au      # flcdrg/chocolatey-au fork, 'simplify' branch
```

Confirm with `choco list --limit-output | Select-String validation` and `Get-Module -ListAvailable Chocolatey-AU`.

## 1. Static review

- No template text, sample URLs, placeholder checksums, or e-mail addresses remain anywhere.
- Nuspec is well-formed XML; `id` matches the folder; `version` matches the install script URL/file names.
- Every `au_SearchReplace` regex matches exactly one assignment line in the install script (test with `Select-String`).
- New `tools\*.ps1` files are UTF-8 with BOM (`Get-Content -AsByteStream -TotalCount 3` → `239 187 191`; PowerShell 7 syntax, use `-Encoding Byte` on 5.1).
- Licence files: present and complete for embedded binaries; absent for download-at-install packages.
- Unsupported OS/architecture paths `throw`.

## 2. `choco pack`

Run from the package directory:

```powershell
choco pack --output-directory $env:TEMP\chocopack
```

The installed validation extension runs the Community Repository rules during pack:

- **Requirements** (`Error|CPMR####`) fail the pack. Fix the underlying metadata; do not delete legitimate metadata or otherwise game the rule to make it pass.
- **Guidelines** and **Suggestions** should be fixed when practical.
- **Notes** are informational; include any that remain in the summary so the maintainer can judge them.

Look a rule up with `choco rule get --name CPMR0030` or at <https://docs.chocolatey.org/en-us/community-repository/moderation/package-validator/rules/>. `choco rule` alone lists everything the extension enforces.

`*.nupkg` is gitignored; delete the output directory afterwards.

## 3. Install and uninstall test (when safe)

Only when the software can reasonably be installed on the current machine and the user has not asked you to avoid it:

```powershell
choco install <id> --source $env:TEMP\chocopack --yes [--params "'/Param:value'"]
choco uninstall <id> --yes
```

Check the Chocolatey log (`$env:ChocolateyInstall\logs\chocolatey.log`) for warnings, confirm shims or Programs and Features entries appear as intended, and confirm uninstall leaves nothing behind. Skip this step for large installers, software requiring licences or reboots, or system-level components, and say so in the summary.

## 4. Run the AU script

With the module installed, running the update is the primary check of the AU script (`_update.ps1` for a new package; `update.ps1` once approved and renamed):

```powershell
cd <package>
.\_update.ps1
# or, when the nuspec already has the target version:
$au_Force = $true; .\_update.ps1
```

Preconditions: `au_GetLatest` talks to an official vendor API/feed over HTTPS, and the user has not asked you to avoid network access. Review the diff it produces to the nuspec and install script (versions, URLs, checksums, release notes) and keep those generated values. Set `$env:github_api_key` (for example in the gitignored `update_vars.ps1`) to avoid GitHub API rate limits. A forced run on an unchanged version appends a `.yyyyMMdd` package-fix segment to the version, so revert that afterwards unless you intend to publish a package fix.

### Exercise the failure branches

A successful run only proves the happy path. Load the callbacks without the trailing `update` call and drive each `'Ignore'` branch by overriding the helpers it depends on with `global:` functions:

```powershell
cd <package>
Invoke-Expression ((Get-Content .\_update.ps1 -Raw) -replace '(?m)^update\b.*$', '')

au_GetLatest                                   # live happy path: expect a hashtable

$real = Get-GitHubReleaseAssets (Find-GitHubRelease 'owner/repo' { $_.tag_name -eq 'v1.2.3' })
function global:Get-GitHubReleaseAssets($release) { $real | Where-Object name -ne 'tool-arm64.exe' }
au_GetLatest                                   # expect: warning + 'Ignore'

function global:Invoke-RestMethod { param($Uri, $Method, $Headers)
    if ("$Uri" -like '*checksums.txt') { throw 'simulated 404' }
    Microsoft.PowerShell.Utility\Invoke-RestMethod @PSBoundParameters }
au_GetLatest                                   # expect: warning + 'Ignore'
```

Run this in a throwaway shell so the overrides do not leak. Cover at least: no matching release, a missing required asset, a failed secondary download, and a manifest missing an entry.

If `Import-Module chocolatey-au` fails, do not install dependencies for this check; use the same isolation technique to exercise `au_GetLatest`, verify each `au_SearchReplace` pattern against the install script, and state in the summary that the AU workflow was not executed.

## 5. Report

Summarise: files created, distribution and install/uninstall decisions, update-script support, each validation step run (with validator output), and anything that could not be verified.
