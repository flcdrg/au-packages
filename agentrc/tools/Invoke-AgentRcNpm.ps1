function Invoke-AgentRcNpm {
    param(
        [string[]] $Arguments,
        [switch] $CaptureOutput
    )

    # Windows PowerShell treats redirected native stderr as an error even on success.
    $ErrorActionPreference = 'Continue'
    $PSNativeCommandUseErrorActionPreference = $false
    if ($CaptureOutput) {
        & $npmPath @Arguments
    } else {
        & $npmPath @Arguments 2>&1 | ForEach-Object { Write-Host $_ }
    }

    if ($LASTEXITCODE -ne 0) {
        throw "npm $($Arguments -join ' ') failed with exit code $LASTEXITCODE."
    }
}
