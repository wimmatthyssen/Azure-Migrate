<#
.SYNOPSIS

A script used to create an Azure Migrate Local Admin account on a standalone non-domain joined Hyper-V host

.DESCRIPTION

A script used to create an Azure Migrate Local Admin account on a standalone non-domain joined Hyper-V host.
This Local Admin account will also added to the following groups: Hyper-V Administrators, Remote Management Users, and Performance Monitor Users.

.NOTES

Filename:       Create_Azure_Migrate_Local_Admin_on_Hyper-V.ps1
Created:        03/12/2020
Last modified:  04/12/2020
Author:         Wim Matthyssen
PowerShell:     5.1
Action:         Change variables were needed to fit your needs.
Disclaimer:     This script is provided "As IS" with no warranties.

.EXAMPLE

.\Create_Azure_Migrate_Local_Admin_on_Hyper-V.ps1

.LINK

#>

## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

## Variables

$global:currenttime= Set-PSBreakpoint -Variable currenttime -Mode Read -Action {$global:currenttime= Get-Date -UFormat "%A %m/%d/%Y %R"}
$foregroundColor1 = "Red"
$writeEmptyLine = "`n"
$writeSeperatorSpaces = " - "


$localUserName = "aa_azmig"

$localUserFullName = $localUserName
$localUserDescription = "Azure Migrate Adminstrator account"


$administratorsGroup = "Administrators"
$hvAdministratorsGroup = "Hyper-V Administrators"
$remoteManagementUsersGroup = "Remote Management Users"
$performanceMonitorUsersGroup = "Performance Monitor Users"

## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

## Prerequisites

## Check if running as Administrator, otherwise close the PowerShell window

$CurrentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
$IsAdministrator = $CurrentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if ($IsAdministrator -eq $false) {
    Write-Host ($writeEmptyLine + "# Please run PowerShell as Administrator" + $writeSeperatorSpaces + $currentTime)`
    -foregroundcolor $foregroundColor1 $writeEmptyLine
    Start-Sleep -s 5
    exit
}

## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

## Create a secure password for the Local Admin account

$secPassword = Read-Host " # Type in a password for the Local Admin account" $localUserName "which meets the complexity requirements" –AsSecureString 

## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

## Create Local Admin account

New-LocalUser -Name $localUserName -Password $secPassword -FullName $localUserFullName -Description $localUserDescription -UserMayNotChangePassword -PasswordNeverExpires –Verbose

Write-Host ($writeEmptyLine + " # Local Admin Account " + $localUserName + " created" + $writeSeperatorSpaces + $currentTime)`
-foregroundcolor $foregroundColor1 $writeEmptyLine

## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

## Add Local Admin account to the required groups

Add-LocalGroupMember -Group $administratorsGroup -Member $localUserName –Verbose
Add-LocalGroupMember -Group $hvAdministratorsGroup -Member $localUserName –Verbose
Add-LocalGroupMember -Group $remoteManagementUsersGroup -Member $localUserName –Verbose
Add-LocalGroupMember -Group $performanceMonitorUsersGroup -Member $localUserName –Verbose

Write-Host ($writeEmptyLine + " # Local Admin Account " + $localUserName + " added to the required groups" + $writeSeperatorSpaces + $currentTime)`
-foregroundcolor $foregroundColor1 $writeEmptyLine

## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
