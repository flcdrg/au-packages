function Stop-CodeGraphProcess {
  # Running shims or the bundled node.exe lock files, which silently prevents the shim being regenerated
  # and stops Chocolatey from cleaning up lib-bkp.
  $shimPath = Join-Path $env:ChocolateyInstall 'bin\codegraph.exe'
  $packageDirs = @(
    (Join-Path $env:ChocolateyInstall 'lib\codegraph'),
    (Join-Path $env:ChocolateyInstall 'lib-bkp\codegraph')
  ) | ForEach-Object { "$_\" }

  $allProcesses = @(Get-CimInstance -ClassName Win32_Process)
  $targets = @($allProcesses | Where-Object {
      $path = $_.ExecutablePath
      $path -and (
        $path -eq $shimPath -or
        @($packageDirs | Where-Object { $path.StartsWith($_, [StringComparison]::OrdinalIgnoreCase) }).Count -gt 0
      )
    })

  $shimProcessIds = @($targets | Where-Object { $_.ExecutablePath -eq $shimPath } | ForEach-Object { $_.ProcessId })
  if ($shimProcessIds.Count -gt 0) {
    $targets += @($allProcesses | Where-Object { $shimProcessIds -contains $_.ParentProcessId })
  }

  $processIds = @($targets | ForEach-Object { $_.ProcessId } | Sort-Object -Unique)
  if ($processIds.Count -eq 0) {
    return
  }

  Write-Warning "Stopping $($processIds.Count) running CodeGraph process(es) (for example MCP servers) so files can be updated. Restart any affected tools afterwards."
  foreach ($processId in $processIds) {
    Stop-Process -Id $processId -Force -ErrorAction SilentlyContinue
  }
  foreach ($processId in $processIds) {
    Wait-Process -Id $processId -Timeout 10 -ErrorAction SilentlyContinue
  }
}
