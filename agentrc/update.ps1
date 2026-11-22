Import-Module chocolatey-au
. ../_scripts/GitHub.ps1

function global:au_GetLatest {
    try {
        $package = Invoke-RestMethod -Uri 'https://registry.npmjs.org/@microsoft%2fagentrc/next' -TimeoutSec 30
    } catch {
        Write-Warning "Could not query the npm registry for AgentRC's next dist-tag: $_"
        return 'Ignore'
    }

    if ($package.name -ne '@microsoft/agentrc') {
        Write-Warning "The npm registry returned unexpected package '$($package.name)'."
        return 'Ignore'
    }

    $version = [string]$package.version
    if ($version -notmatch '^\d+\.\d+\.\d+(?:-[A-Za-z0-9-]+(?:\.[A-Za-z0-9-]+)*)?$') {
        Write-Warning "The npm next dist-tag contains an unsupported version: '$version'."
        return 'Ignore'
    }
    if (-not $package.bin.agentrc -or
        $package.engines.node -notmatch '>=\s*22' -or
        $package.dist.integrity -notmatch '^sha512-' -or
        $package.dist.tarball -notmatch '^https://registry\.npmjs\.org/') {
        Write-Warning "The npm next package $version is missing the expected CLI, Node.js requirement, or registry integrity metadata."
        return 'Ignore'
    }

    $chocolateyVersion = $version
    $prereleaseSeparator = $version.IndexOf('-')
    if ($prereleaseSeparator -ge 0) {
        $chocolateyVersion = $version.Substring(0, $prereleaseSeparator + 1) +
            $version.Substring($prereleaseSeparator + 1).Replace('.', '')
    }

    @{
        Version      = $chocolateyVersion
        NpmVersion   = $version
        ReleaseNotes = "https://www.npmjs.com/package/@microsoft/agentrc/v/$version"
    }
}

function global:au_SearchReplace {
    @{
        'tools\chocolateyInstall.ps1' = @{
            "(^\s*\`$npmPackageVersion\s*=\s*)('.*')" = "`$1'$($Latest.NpmVersion)'"
        }
        'tools\chocolateyUninstall.ps1' = @{
            "(^\s*\`$npmPackageVersion\s*=\s*)('.*')" = "`$1'$($Latest.NpmVersion)'"
        }
    }
}

function global:au_AfterUpdate ($Package) {
    Update-ReleaseNotes $Package
}

update -ChecksumFor none
