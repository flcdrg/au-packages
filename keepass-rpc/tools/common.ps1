$packageSearch = 'KeePass Password Safe'

function Get-KeePassPluginsPath {
    Write-Verbose "Searching registry for installed KeePass..."
    $regPath = Get-ItemProperty -Path `
		@('HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*',
    'HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*',
    'HKCU:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*') `
		-ErrorAction:SilentlyContinue `
		| Where-Object { `
			$_.DisplayName -like "$packageSearch*" `
			-and $_.DisplayVersion -ge 2.0 `
			-and $_.DisplayVersion -lt 3.0 `
		} `
		| ForEach-Object {$_.InstallLocation}

    $installPath = $regPath

    if (! $installPath) {
        Write-Verbose "Searching $env:ChocolateyBinRoot for portable install..."
        $binRoot = Get-BinRoot
        $portPath = Join-Path $binRoot "keepass"
        $installPath = Get-ChildItem -Directory $portPath* -ErrorAction SilentlyContinue
    }

    if (! $installPath) {
        Write-Verbose "Searching $env:Path for unregistered install..."
        $installFullName = (Get-Command keepass -ErrorAction SilentlyContinue).Path
        if (! $installFullName) {
            $installPath = [io.path]::GetDirectoryName($installFullName)
        }
    }

    if (! $installPath) {
        Write-Warning "$($packageSearch) not found."
        throw
    }

    Write-Verbose "`t...found."

    Write-Verbose "Searching for plugin directory..."
    $pluginPath = (Get-ChildItem -Directory $installPath\Plugin*).FullName
    if ($pluginPath.Count -eq 0) {
        $pluginPath = Join-Path $installPath "Plugins"
        [System.IO.Directory]::CreateDirectory($pluginPath)
    }
    return $pluginPath
}
