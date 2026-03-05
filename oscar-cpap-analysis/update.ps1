Import-Module chocolatey-au
# Import-Module "$PSScriptRoot\..\..\chocolatey-au\src\chocolatey-au.psd1"

function global:au_SearchReplace {
	@{
		'tools\chocolateyInstall.ps1' = @{
			'(^\s*url\s*=\s*)(".*"|''.*'')'   = "`$1'$($Latest.Url32)'"
			"(^\s*checksum\s*=\s*)('.*')"      = "`$1'$($Latest.Checksum32)'"
			'(^\s*url64bit\s*=\s*)(".*"|''.*'')' = "`$1'$($Latest.Url64)'"
			"(^\s*checksum64\s*=\s*)('.*')"    = "`$1'$($Latest.Checksum64)'"
		}
	}
}

function global:au_GetLatest {
	try {
		$response = Invoke-WebRequest -Uri 'http://apneaboard.net/OSCAR/versions.xml' -UseBasicParsing
		$xml = [xml]$response.Content.Trim([char]0xFEFF, [char]0x200B)

		$releaseGroup = $xml.OSCAR.group | Where-Object { $_.id -eq 'release' } | Select-Object -First 1
		$allPlatform = $releaseGroup.platform | Where-Object { $_.id -eq 'All' } | Select-Object -First 1
		$version = $allPlatform.version

		if (-not $version) {
			throw 'Could not determine release version from versions.xml'
		}

		$url32 = "https://www.sleepfiles.com/OSCAR/$version/OSCAR-$version-Win32-Qt5.exe"
		$url64 = "https://www.sleepfiles.com/OSCAR/$version/OSCAR-$version-Win64-Qt5.exe"

		foreach ($url in @($url32, $url64)) {
			$head = Invoke-WebRequest -Uri $url -Method Head -UseBasicParsing
			if ($head.StatusCode -ne 200) {
				throw "Installer URL check failed: $url"
			}
		}

		return @{
			Version      = $version
			Url32        = $url32
			Url64        = $url64
			ReleaseNotes = 'http://www.apneaboard.com/wiki/index.php/OSCAR_Release_Notes'
		}
	}
	catch {
		Write-Error $_
		return @{}
	}
}

update -NoReadme
