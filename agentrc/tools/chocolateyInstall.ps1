$ErrorActionPreference = 'Stop'
. "$PSScriptRoot\Invoke-AgentRcNpm.ps1"

$npmPackageVersion = '2.0.1-103'
if ($npmPackageVersion -notmatch '^\d+\.\d+\.\d+(?:-[A-Za-z0-9-]+(?:\.[A-Za-z0-9-]+)*)?$') {
    throw "Unexpected npm package version '$npmPackageVersion'."
}
$packageVersion = $npmPackageVersion
$prereleaseSeparator = $npmPackageVersion.IndexOf('-')
if ($prereleaseSeparator -ge 0) {
    $packageVersion = $npmPackageVersion.Substring(0, $prereleaseSeparator + 1) +
        $npmPackageVersion.Substring($prereleaseSeparator + 1).Replace('.', '')
}
if ($env:ChocolateyPackageVersion -ne $packageVersion) {
    throw "Expected Chocolatey package version $packageVersion but found $env:ChocolateyPackageVersion."
}

$nodeCommand = Get-Command node.exe -ErrorAction SilentlyContinue
if (-not $nodeCommand) {
    throw 'Node.js 22 or later is required. Install the nodejs-lts dependency and refresh the environment.'
}
$nodeVersionOutput = & $nodeCommand.Source --version
if ($LASTEXITCODE -ne 0 -or $nodeVersionOutput -notmatch '^v?(\d+\.\d+\.\d+)') {
    throw "Could not determine the Node.js version from '$($nodeCommand.Source)'."
}
$nodeVersion = [version]$Matches[1]
if ($nodeVersion -lt [version]'22.0.0') {
    throw "AgentRC requires Node.js 22 or later. Detected $nodeVersion."
}

$npmCommand = Get-Command npm.cmd -ErrorAction SilentlyContinue
if (-not $npmCommand) {
    throw 'npm.cmd was not found. The nodejs-lts dependency must provide Node.js and npm.'
}

$npmPrefixOutput = Invoke-AgentRcNpm -Arguments @('config', 'get', 'prefix') -CaptureOutput
$npmPrefix = "$($npmPrefixOutput | Select-Object -Last 1)".Trim()
if (-not $npmPrefix -or -not (Test-Path -LiteralPath $npmPrefix -PathType Container)) {
    throw "The global npm prefix '$npmPrefix' does not exist."
}

Invoke-AgentRcNpm -Arguments @('install', '--global', "@microsoft/agentrc@$npmPackageVersion")

$npmRootOutput = Invoke-AgentRcNpm -Arguments @('root', '--global') -CaptureOutput
$npmRoot = "$($npmRootOutput | Select-Object -Last 1)".Trim()
$packageJson = Join-Path $npmRoot '@microsoft\agentrc\package.json'
if (-not (Test-Path -LiteralPath $packageJson -PathType Leaf)) {
    throw "npm reported success, but AgentRC was not found at '$packageJson'."
}
$installedPackage = Get-Content -LiteralPath $packageJson -Raw | ConvertFrom-Json
if ($installedPackage.version -ne $npmPackageVersion) {
    throw "Expected AgentRC $npmPackageVersion, but found $($installedPackage.version)."
}

$commandPath = Join-Path $npmPrefix 'agentrc.cmd'
if (-not (Test-Path -LiteralPath $commandPath -PathType Leaf)) {
    throw "npm installed AgentRC but did not create its command shim at '$commandPath'."
}
Install-ChocolateyPath -PathToInstall $npmPrefix -PathType User
