$ErrorActionPreference = 'Stop'; # stop on all errors

$url = 'https://vstsagentpackage.azureedge.net/agent/2.188.3/vsts-agent-win-x86-2.188.3.zip'
$url64 = 'https://vstsagentpackage.azureedge.net/agent/2.188.3/vsts-agent-win-x64-2.188.3.zip'
$checksum = '34ff2ef0ec0e1e4553a370741ef3b7cc7bcf3c6928507522d46e61e190caa485'
$checksum64 = '5ca06033d1630f9b3d8df973b4149edc9aa4a8bbe0a96e7105b2785cb1ffa9bd'

$pp = Get-PackageParameters

if (!$pp['Directory']) { $pp['Directory'] = 'c:\agent' }

$configOpts = @()

# We only run config.cmd if a Url is supplied
if ($pp['Url']) {

    $configOpts = @('configure', '--unattended', '--acceptTeeEula')
    $configOpts += @('--url', $pp['Url'])
    if ($pp['CollectionName']) {
        $configOpts += @('--CollectionName', $pp['CollectionName'])
    }
    if ($pp['Token']) {
        $configOpts += @("--auth", "pat", "--token", $pp['Token'])
    }
    else {
        if (!$pp['Auth']) {
            Write-Error "You need to specify an auth type with /Auth= 'negotiate', 'alt' or 'integrated'"
        }
        
        $configOpts += @("--auth", $($pp['Auth']))

        if ($pp['Auth'] -ine 'integrated') {
            $username = $pp['Username']
            $password = $pp['Password']

            if (!$username -or !$password) {
                Write-Error "You must supply /username and /password"
            }
            
            $configOpts += @("--userName", $username, "--password", $password)
        }
    }
    # Are we a deployment agent, environment, or a build agent?
    if ($pp['DeploymentGroup']) {
        Write-Verbose "Deployment Agent"

        if (!$pp['DeploymentGroupName'] -or !$pp['ProjectName']) {
            Write-Error "Must specify /DeploymentGroupName and /ProjectName"
        }

        $configOpts += @("--deploymentGroup", "--deploymentGroupName", $pp['DeploymentGroupName'])
        if ($pp['DeploymentGroupTags']) {
            $configOpts += @("--addDeploymentGroupTags", "--deploymentGroupTags", $pp['DeploymentGroupTags'])
        }

        if ($pp['ProjectName']) {
            $configOpts += @('--projectName', $pp['ProjectName'])
        }
    }
    elseif ($pp['Environment']) {
        Write-Verbose "Environment Agent"

        if (!$pp['EnvironmentName'] -or !$pp['ProjectName']) {
            Write-Error "Must specify /EnvironmentName and /ProjectName"
        }

        $configOpts += @("--environment", "--environmentName", $pp['EnvironmentName'])

        if ($pp['EnvironmentTags']) {
            $configOpts += @("--addVirtualMachineResourceTags", "--virtualMachineResourceTags", $pp['EnvironmentTags'])
        }

        if ($pp['ProjectName']) {
            $configOpts += @('--projectName', $pp['ProjectName'])
        }
    }
    else {
        if (!$pp['Pool']) { $pp['Pool'] = 'default'}
      
        $configOpts += @("--pool", $pp['Pool'])
    }
    
    # AutoLogon(interactive) or as a service
    if ($pp['AutoLogon']) {
        $configOpts += @('--runAsAutoLogon', '--noRestart')
    }
    else {
        $configOpts += @('--runAsService')
    }

    if ($pp['LogonAccount']) {
        $configOpts += @("--windowsLogonAccount", $pp['LogonAccount'])

        if ($pp['LogonPassword']) {
            $configOpts += @("--windowsLogonPassword", $pp['LogonPassword'])
        }
    }

    # Work directory
    if ($pp['Work']) {
        $configOpts += @("--work", $pp['Work'])
    }

    # Agent name
    if ($pp['AgentName']) {
        $configOpts += @("--agent", $pp['AgentName'])
    }

    # Replace existing agent
    if ($pp['Replace']) {
        $configOpts += @("--replace")
    }

    # Self-signed certificate
    if ($pp['SslSkipCertValidation']) {
        $configOpts += @("--sslskipcertvalidation")
    }

    # Git use SChannel
    if ($pp['GitUseSChannel']) {
        $configOpts += @("--gituseschannel")
    }

    # Client Certificate
    if ($pp['UseClientCertificate']) {
        if (!$pp['SslCaCert'] -or !$pp['SslClientCert'] -or !$pp['SslClientCertKey'] -or !$pp['SslClientCertArchive'] -or !$pp['SslClientCertPassword']) {
            Write-Error "Must specify /SslCaCert, /SslClientCert, /SslClientCertKey, /SslClientCertArchive and /SslClientCertPassword"
        }
        $configOpts += @(
            "--sslcacert", $pp['SslCaCert'],
            "--sslclientcert", $pp['SslClientCert'],
            "--sslclientcertkey", $pp['SslClientCertKey'],
            "--sslclientcertarchive", $pp['SslClientCertArchive'],
            "--sslclientcertpassword", $pp['SslClientCertPassword']
        )
    }

    # Proxy
    if ($pp['ProxyUrl']) {
        $configOpts += @("--proxyurl", $pp['ProxyUrl'])

        if ($pp['ProxyUserName']) {
            $configOpts += @("--proxyusername", $pp['ProxyUserName'])

            if ($pp['ProxyPassword']) {
                $configOpts += @("--proxypassword", $pp['ProxyPassword'])
            }
        }        
    }
}

$packageArgs = @{
    packageName    = $env:ChocolateyPackageName
    unzipLocation  = $pp['Directory']
    url            = $url
    url64bit       = $url64

    checksum       = $checksum
    checksumType   = 'sha256'
    checksum64     = $checksum64
    checksumType64 = 'sha256'
}

Install-ChocolateyZipPackage @packageArgs

if ($configOpts.Count) {
    Write-Verbose "$($packageArgs.unzipLocation)\bin\Agent.Listener.exe configure $configOpts"
    & "$($packageArgs.unzipLocation)\bin\Agent.Listener.exe" $configOpts
}
