# Ensure the script runs with administrative privileges
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Error "This script must be run as an Administrator."
    exit
}

# Identify and Remove MS Teams Installations
Write-Host "Identifying installed MS Teams packages for all users..."
$teamsPackages = Get-AppxPackage -AllUsers | Where-Object {$_.PackageFullName -like "*Teams*"}
$provisionedPackages = Get-AppxProvisionedPackage -Online | Where-Object {$_.PackageName -like "*Teams*"}

if ($teamsPackages.Count -eq 0 -and $provisionedPackages.Count -eq 0) {
    Write-Host "No MS Teams installations found."
} else {
    Write-Host "Found the following MS Teams packages:"
    $teamsPackages | ForEach-Object {Write-Host $_.PackageFullName}
    $provisionedPackages | ForEach-Object {Write-Host $_.PackageName}
}

# Remove provisioned MS Teams packages
$provisionedPackages | ForEach-Object {
    if ($_) {
        Write-Host "Removing provisioned package: $($_.PackageName)"
        Dism /Online /Remove-ProvisionedAppxPackage /PackageName:$($_.PackageName)
    } else {
        Write-Host "No provisioned packages to remove."
    }
}

# Remove installed MS Teams packages for all users
$teamsPackages | ForEach-Object {
    if ($_) {
        Write-Host "Removing installed package for all users: $($_.PackageFullName)"
        Remove-AppxPackage -AllUsers -Package $_.PackageFullName
    } else {
        Write-Host "No installed packages to remove."
    }
}

# Uninstall Microsoft Teams Meeting Add-in for Microsoft Office Using MSIExec
Write-Host "Uninstalling Microsoft Teams Meeting Add-in for Microsoft Office..."

# Check if WMIC is available and try to get the GUID of the add-in
try {
    if (Get-Command wmic -ErrorAction SilentlyContinue) {
        Write-Host "WMIC is available. Searching for the Teams Meeting Add-in GUID..."

        # Find the Teams Meeting Add-in for Microsoft Office GUID using WMIC
        $teamsAddinGUID = (wmic product where "name like 'Microsoft Teams Meeting Add-in for Microsoft Office'" get IdentifyingNumber | findstr /i /r "[0-9A-F]{8}-[0-9A-F]{4}-[0-9A-F]{4}-[0-9A-F]{4}-[0-9A-F]{12}").Trim()

        if (-not [string]::IsNullOrEmpty($teamsAddinGUID)) {
            Write-Host "Found Microsoft Teams Meeting Add-in for Microsoft Office, GUID: $teamsAddinGUID"
            Write-Host "Uninstalling using MSIExec..."

            # Use msiexec to uninstall the add-in by GUID
            $msiExecCommand = "msiexec.exe /x $teamsAddinGUID /quiet /norestart"
            Invoke-Expression $msiExecCommand
            Write-Host "Uninstall process initiated for Microsoft Teams Meeting Add-in for Microsoft Office."
        } else {
            Write-Host "No GUID found for Microsoft Teams Meeting Add-in for Microsoft Office. Skipping uninstallation."
        }
    } else {
        Write-Host "WMIC is not available on this system."
    }
}
catch {
    Write-Host "An error occurred while trying to get the Microsoft Teams Meeting Add-in GUID: $_"
}

# Manually Delete Global Teams-Related Folders
Write-Host "Deleting global Teams-related folders..."
$globalFoldersToDelete = @(
    "C:\Program Files (x86)\Microsoft\Teams",
    "C:\Program Files (x86)\Microsoft\TeamsMeetingAddin",
    "C:\Program Files (x86)\Microsoft\TeamsPresenceAddin"
)

foreach ($folder in $globalFoldersToDelete) {
    if (Test-Path $folder) {
        Write-Host "Deleting folder: $folder"
        Remove-Item -Recurse -Force -Path $folder
    } else {
        Write-Host "Folder not found: $folder"
    }
}

# Clean up Scheduled Tasks related to Teams
Write-Host "Cleaning up any leftover scheduled tasks related to Microsoft Teams..."
$scheduleTasks = Get-ScheduledTask | Where-Object { $_.TaskName -like "*Teams*" }

if ($scheduleTasks) {
    $scheduleTasks | ForEach-Object {
        Write-Host "Removing scheduled task: $($_.TaskName)"
        Unregister-ScheduledTask -TaskName $_.TaskName -Confirm:$false
    }
} else {
    Write-Host "No Teams-related scheduled tasks found."
}

# Remove Chocolatey package folder from lib directory
Write-Host "Cleaning up Chocolatey package folder for Microsoft Teams 2..."
$chocoPackageFolder = Join-Path $env:ChocolateyInstall "lib\microsoft-teams-new-bootstrapper"
if (Test-Path $chocoPackageFolder) {
    Write-Host "Deleting Chocolatey package folder: $chocoPackageFolder"
    Remove-Item -Recurse -Force -Path $chocoPackageFolder
} else {
    Write-Host "No Chocolatey package folder found for Microsoft Teams 2."
}

Write-Host "Microsoft Teams 2 uninstallation and cleanup process completed successfully."