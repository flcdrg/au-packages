# Defaults
$toolsPath = Split-Path -Parent $MyInvocation.MyCommand.Definition
$packageParameters = Get-PackageParameters

# Download and unzip consul
$package = @{
  PackageName   = 'consul'
  Url           = 'https://releases.hashicorp.com/consul/1.20.1/consul_1.20.1_windows_386.zip'
  Url64bit      = 'https://releases.hashicorp.com/consul/1.20.1/consul_1.20.1_windows_amd64.zip'
  UnzipLocation = $toolsPath
  Checksum      = 'b0a4f5bb78b4789e8a96222919c676397c8946d80f03c8349ef5e86786635bbf'
  Checksum64    = '9b48a9404997d2b159ca5e5c6be257bfc5e8a46b0f157c50ae1d506782009024'
  ChecksumType  = 'sha256'
}
Install-ChocolateyZipPackage @package

# Install Env CONSUL_HTTP_ADDR
if ($packageParameters["apiaddr"] -ne "") {
  Install-ChocolateyEnvironmentVariable "CONSUL_HTTP_ADDR" $packageParameters["apiaddr"]
}

# Default to install with Windows service
if (-not ($packageParameters["noservice"])) {
  $serviceName = "consul"
  $wrapperExe = "$env:ChocolateyInstall\bin\nssm.exe"
  $serviceInstallationDirectory = "$env:PROGRAMDATA\consul"
  $serviceLogDirectory = "$serviceInstallationDirectory\logs"
  $serviceConfigDirectory = "$serviceInstallationDirectory\config"
  $serviceDataDirectory = "$serviceInstallationDirectory\data"

  # Create Service Directories
  Write-Host "Creating $serviceLogDirectory"
  New-Item -ItemType directory -Path "$serviceLogDirectory" -ErrorAction SilentlyContinue | Out-Null
  Write-Host "Creating $serviceConfigDirectory"
  New-Item -ItemType directory -Path "$serviceConfigDirectory" -ErrorAction SilentlyContinue | Out-Null

  # Create event log source
  # User -Force to avoid "A key at this path already exists" exception. Overwrite not an issue since key is not further modified
  $registryPath = 'HKLM:\SYSTEM\CurrentControlSet\services\eventlog\Application'
  New-Item -Path $registryPath -Name consul -Force | Out-Null
  # Set EventMessageFile value
  Set-ItemProperty $registryPath\consul EventMessageFile "C:\Windows\Microsoft.NET\Framework64\v2.0.50727\EventLogMessages.dll" | Out-Null

  # Set up task scheduler for log rotation
  $logrotate = ('%SYSTEMROOT%\System32\forfiles.exe /p \"{0}\" /s /m *.* /c \"cmd /c Del @path\" /d -7' -f "$serviceLogDirectory")
  SchTasks.exe /Create /SC DAILY /TN ""ConsulLogrotate"" /TR ""$($logrotate)"" /ST 09:00 /F | Out-Null

  # Set up task scheduler for log rotation. Only works for Powershell 4 or Server 2012R2 so this block can replace
  # using SchTasks.exe for registering services once machines have retired the older version of PS or upgraded to 2012R2
  #$command = ('$now = Get-Date; dir "{0}" | where {{$_.LastWriteTime -le $now.AddDays(-7)}} | del -whatif' -f $serviceLogDirectory)
  #$action = New-ScheduledTaskAction -Execute 'Powershell.exe' -Argument "-NoProfile -WindowStyle Hidden -command $($command)"
  #$trigger = New-ScheduledTaskTrigger -Daily -At 9am
  #Register-ScheduledTask -Action $action -Trigger $trigger -TaskName "ConsulLogrotate" -Description "Log rotation for consul"

  #Uninstall service if it already exists. Stops the service first if it's running
  $service = Get-Service $serviceName -ErrorAction SilentlyContinue
  if ($service) {
    Write-Host "Uninstalling existing service"
    if ($service.Status -ne "Stopped" -and $service.Status -ne "Stopping") {
      Write-Host "Stopping consul process ..."
      $service.Stop();
    }

    $service.WaitForStatus("Stopped", (New-TimeSpan -Minutes 1));
    if ($service.Status -ne "Stopped") {
      throw "$serviceName could not be stopped within the allotted timespan.  Stop the service and try again."
    }

    $service = Get-WmiObject -Class Win32_Service -Filter "Name='$serviceName'"
    $service.delete() | Out-Null
  }

  $serviceArgs = $packageParameters["agentargs"]
  $serviceArgs = "agent -ui -config-dir=$serviceConfigDirectory -data-dir=$serviceDataDirectory $serviceArgs"
  Write-Host "Installing service: $serviceName"
  # Install the service
  & $wrapperExe install $serviceName $(Join-Path $toolsPath "consul.exe") $serviceArgs | Out-Null
  & $wrapperExe set $serviceName AppEnvironmentExtra GOMAXPROCS=$env:NUMBER_OF_PROCESSORS | Out-Null
  & $wrapperExe set $serviceName ObjectName NetworkService | Out-Null
  & $wrapperExe set $serviceName AppStdout "$serviceLogDirectory\consul-output.log" | Out-Null
  & $wrapperExe set $serviceName AppStderr "$serviceLogDirectory\consul-error.log" | Out-Null
  & $wrapperExe set $serviceName AppRotateBytes 10485760 | Out-Null
  & $wrapperExe set $serviceName AppRotateFiles 1 | Out-Null
  & $wrapperExe set $serviceName AppRotateOnline 1 | Out-Null

  Write-Verbose "Service installed"

  # When nssm fully supports Rotate/Post Event hooks
  # $command = ('$now = Get-Date; dir "{0}" | where {{$_.LastWriteTime -le $now.AddDays(-7)}} | del -whatif' -f $serviceLogDirectory)
  # $action = ("Powershell.exe -NoProfile -WindowStyle Hidden -command '$({{0}})'" -f $command)
  # & $wrapperExe set consul AppEvents "Rotate/Post" $action | Out-Null

  # Restart service on failure natively via Windows sc. There is a memory leak if service restart is performed via NSSM
  # The NSSM configuration will set the default behavior of NSSM to stop the service if
  # consul fails (for example, unable to resolve cluster) and end the nssm.exe and consul.exe process.
  # The sc configuration will set Recovery under the Consul service properties such that a new instance will be started on failure,
  # spawning new nssm.exe and consul.exe processes. In short, nothing changed from a functionality perspective (the service will
  # still attempt to restart on failure) but this method kills the nssm.exe process thus avoiding memory hog.
  & $wrapperExe set $serviceName AppExit Default Exit | Out-Null
  Write-Verbose "sc failure"
  cmd.exe /c "sc failure $serviceName reset= 0 actions= restart/60000" | Out-Null

  Write-Verbose "Stop service"
  # Let this call to Get-Service throw if the service does not exist
  $service = Get-Service $serviceName
  if ($service.Status -ne "Stopped" -and $service.Status -ne "Stopping") {
    $service.Stop()
  }

  Write-Verbose "Wait for service to stop"
  $service.WaitForStatus("Stopped", (New-TimeSpan -Minutes 1));

  Write-Verbose "Start service"
  Start-Service $serviceName

  Write-Host "Installed service: $serviceName"
}
