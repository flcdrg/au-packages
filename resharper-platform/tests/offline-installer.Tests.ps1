BeforeAll {
    . "$PSScriptRoot\..\common.ps1"
}

Describe 'JetBrains offline release detection' {
    BeforeEach {
        $script:preReleaseMarketing = '2026.3 RC 1'
        $script:preReleaseVersion = '263.0.20261104.113413-rc01'

        Mock Invoke-RestMethod {
            param($Uri)

            switch -Wildcard ($Uri) {
                '*resharper-version.json' { return '263.0.20261106.203405' }
                '*resharper-version-eap.json' { return $script:preReleaseVersion }
                '*resharper-updates*.json' {
                    $marketing = if ($Uri -like '*-eap.json') { $script:preReleaseMarketing } else { '2026.3' }
                    return @{
                        AllPackages = @{
                            InstallablePackage = @(
                                @{
                                    PackageMetadata = @{ Id = 'JetBrains.ReSharper.src' }
                                    ProductInfo = (@{ VersionMarketingString = $marketing } | ConvertTo-Json)
                                }
                            )
                        }
                    }
                }
                '*.zip.sha256' {
                    $filename = ([Uri]$Uri).Segments[-1] -replace '\.sha256$', ''
                    return "$('a' * 64) *$filename`n"
                }
                default { throw "Unexpected URL: $Uri" }
            }
        }
    }

    It 'uses the stable ZIP checksum but exposes the extracted executable filename' {
        $latest = GetJetbrainsReSharperPlatformLatestRelease 'Release'

        $latest.Url32 | Should -Be 'https://download.jetbrains.com/resharper/dotUltimate.2026.3/JetBrains.dotUltimate.2026.3.zip'
        $latest.Checksum32 | Should -Be ('a' * 64)
        $latest.Filename | Should -Be 'JetBrains.dotUltimate.2026.3.exe'
        $latest.Version | Should -Be '263.0.20261106.203405'
        $latest.MarketingVersion | Should -Be '2026.3'
        Should -Invoke Invoke-RestMethod -Times 1 -Exactly -ParameterFilter {
            $Uri -eq 'https://download.jetbrains.com/resharper/dotUltimate.2026.3/JetBrains.dotUltimate.2026.3.zip.sha256'
        }
    }

    It 'preserves checked installer names and version normalization for <Marketing>' -ForEach @(
        @{ Marketing = '2026.3 RC 1'; Version = '263.0.20261104.113413-rc01'; Dotted = '2026.3.RC1'; SemVer = '2026.3-RC01' }
        @{ Marketing = '2026.3 EAP 9'; Version = '263.0.20261028.100000eap9'; Dotted = '2026.3.EAP9'; SemVer = '2026.3-EAP09' }
    ) {
        $script:preReleaseMarketing = $Marketing
        $script:preReleaseVersion = $Version
        $latest = GetJetbrainsReSharperPlatformLatestRelease 'Release-EAP'

        $latest.Url32 | Should -Be "https://download.jetbrains.com/resharper/dotUltimate.$Dotted/JetBrains.dotUltimate.$Dotted.Checked.zip"
        $latest.Filename | Should -Be "JetBrains.dotUltimate.$Dotted.Checked.exe"
        $latest.MarketingVersion | Should -Be $SemVer
        $latest.Version | Should -Be ($Version -replace 'eap(\d)$', '-eap0$1')
    }

    It 'keeps platform dependency versions separate from product versions' {
        $latest = GetJetbrainsProductLatest

        $latest.Streams['Release'].Version | Should -Be '2026.3'
        $latest.Streams['Release'].PlatformVersion | Should -Be '263.0.20261106.203405'
        $latest.Streams['Release-Eap'].Version | Should -Be '2026.3-RC01'
        $latest.Streams['Release-Eap'].PlatformVersion | Should -Be '263.0.20261104.113413-rc01'
        $latest.Streams['Release-Eap'].Filename | Should -Be 'JetBrains.dotUltimate.2026.3.RC1.Checked.exe'
    }

    It 'skips a missing optional EAP archive without losing the stable stream' {
        Mock Invoke-RestMethod {
            $response = [System.Net.Http.HttpResponseMessage]::new([System.Net.HttpStatusCode]::NotFound)
            throw [Microsoft.PowerShell.Commands.HttpResponseException]::new('Not found', $response)
        } -ParameterFilter { $Uri -like '*.Checked.zip.sha256' }
        Mock Write-Warning {}

        $latest = GetJetbrainsReSharperPlatformLatest

        $latest.Streams.Count | Should -Be 1
        $latest.Streams['Release'].Filename | Should -Be 'JetBrains.dotUltimate.2026.3.exe'
        Should -Invoke Write-Warning -Times 1 -Exactly -ParameterFilter { $Message -like '*installer is not available*' }
    }

    It 'does not hide other download failures' {
        Mock Invoke-RestMethod { throw 'Download failed' } -ParameterFilter { $Uri -like '*.zip.sha256' }

        { GetJetbrainsReSharperPlatformLatestRelease 'Release' } | Should -Throw '*Download failed*'
        { GetJetbrainsReSharperPlatformLatestRelease 'Release-EAP' } | Should -Throw '*Download failed*'
    }
}

Describe 'JetBrains offline platform installation' {
    BeforeAll {
        function Install-ChocolateyZipPackage {
            param($PackageName, $Url, $UnzipLocation, $Checksum, $ChecksumType)
        }
    }

    BeforeEach {
        $script:packagePath = Join-Path $TestDrive ([Guid]::NewGuid().ToString())
        $toolsPath = New-Item (Join-Path $script:packagePath 'tools') -ItemType Directory
        $script:installScript = Join-Path $toolsPath 'chocolateyinstall.ps1'
        Copy-Item "$PSScriptRoot\..\tools\chocolateyinstall.ps1" $script:installScript
        $source = Get-Content $script:installScript -Raw
        $script:filename = [regex]::Match($source, "(?m)^\`$filename = '([^']+)'").Groups[1].Value
        $script:expectedUrl = [regex]::Match($source, "(?m)^\`$url = '([^']+)'").Groups[1].Value
        $script:expectedChecksum = [regex]::Match($source, "(?m)^\`$checksum = '([^']+)'").Groups[1].Value

        Mock Install-ChocolateyZipPackage {
            New-Item (Join-Path $UnzipLocation $script:filename) -ItemType File -Force | Out-Null
            New-Item (Join-Path $UnzipLocation 'payload.dat') -ItemType File -Force | Out-Null
            $nested = New-Item (Join-Path $UnzipLocation 'payload') -ItemType Directory -Force
            New-Item (Join-Path $nested 'helper.exe') -ItemType File -Force | Out-Null
        }
    }

    It 'extracts the archive alongside the installer, excludes all executables from shimming, and can rerun' {
        & $script:installScript
        & $script:installScript

        Should -Invoke Install-ChocolateyZipPackage -Times 2 -Exactly -ParameterFilter {
            $UnzipLocation -eq $script:packagePath -and $Url -eq $script:expectedUrl -and
            $Url -like '*.zip' -and $Checksum -eq $script:expectedChecksum -and $ChecksumType -eq 'sha256'
        }
        Join-Path $script:packagePath $script:filename | Should -Exist
        Join-Path $script:packagePath "$($script:filename).ignore" | Should -Exist
        Join-Path $script:packagePath 'payload\helper.exe.ignore' | Should -Exist
        Join-Path $script:packagePath 'payload.dat' | Should -Exist
    }

    It 'fails explicitly if the archive lacks the expected installer' {
        Mock Install-ChocolateyZipPackage {}

        { & $script:installScript } | Should -Throw '*offline archive did not contain the expected installer*'
    }

    It 'propagates download or extraction failures' {
        Mock Install-ChocolateyZipPackage { throw 'Extraction failed' }

        { & $script:installScript } | Should -Throw '*Extraction failed*'
    }
}
