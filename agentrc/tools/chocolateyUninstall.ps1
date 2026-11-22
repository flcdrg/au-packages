$ErrorActionPreference = 'Stop'
. "$PSScriptRoot\Invoke-AgentRcNpm.ps1"

$npmPackageVersion = '2.0.1-103'
$npmCommand = Get-Command npm.cmd -ErrorAction SilentlyContinue
if (-not $npmCommand) {
    throw 'npm.cmd is unavailable; cannot safely remove the AgentRC global npm package.'
}
$npmPath = $npmCommand.Source

$npmRootOutput = Invoke-AgentRcNpm -Arguments @('root', '--global') -CaptureOutput
$npmRoot = "$($npmRootOutput | Select-Object -Last 1)".Trim()
$packageJson = Join-Path $npmRoot '@microsoft\agentrc\package.json'
if (-not (Test-Path -LiteralPath $packageJson -PathType Leaf)) {
    Write-Warning 'AgentRC is already absent from this user''s global npm prefix.'
    return
}

$installedPackage = Get-Content -LiteralPath $packageJson -Raw | ConvertFrom-Json
if ($installedPackage.version -ne $npmPackageVersion) {
    Write-Host "Leaving AgentRC $($installedPackage.version) installed; it is not the npm version $npmPackageVersion being removed."
    return
}

Invoke-AgentRcNpm -Arguments @('uninstall', '--global', '@microsoft/agentrc')

if (Test-Path -LiteralPath $packageJson -PathType Leaf) {
    throw "npm completed the uninstall command but AgentRC remains at '$packageJson'."
}

# The npm global prefix is shared by other packages, so keep its PATH entry.
