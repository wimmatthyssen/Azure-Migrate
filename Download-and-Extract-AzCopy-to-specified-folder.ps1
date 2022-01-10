<#
.SYNOPSIS

A script used to download and extract the latest AzCopy Windows 64-bit executable (.exe) file into a specified foler (e.g. C:\Wbin\ folder).

.DESCRIPTION

The latest AzCopy Windows 64-bit executable (.exe) file will be downloaded from a static download link.
The downloaded .zip file will be extracted, and made availabele into the specified folder provided by the user when running the script.
At the end the directory location of the AzCopy executable will also be added to the system path for ease of use.

.NOTES

Filename:       Download-and-Extract-AzCopy-to-specified-folder.ps1
Created:        02/03/21
Last modified:  10/01/22
Author:         Wim Matthyssen
PowerShell:     5.1
Requires:       -RunAsAdministrator
OS:             Windows 10, Windows 11, Windows Server 2016, Windows Server 2019 and Windows Server 2022
Version:        2.0
Action:         Change variables were needed to fit your needs.
Disclaimer:     This script is provided "As Is" with no warranties.

.EXAMPLE

.\Download-and-Extract-AzCopy-to-specified-folder.ps1

.LINK

https://wmatthyssen.com/2021/03/03/powershell-azcopy-windows-64-bit-download-and-silent-installation/
#>

## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

## Variables

$managementToolsFolderName = Read-Host "Please enter your management or administrator tools foldername (e.g. Wbin or AdminTools)" # Example: Wbin or AdminTools
$managementToolsFolderPath = "C:\" + $managementToolsFolderName +"\"
$itemType = "Directory"
$azCopyFolderName = "AzCopy"
$azCopyFolder = $managementToolsFolderPath  + $azCopyFolderName 
$azCopyUrl = "https://aka.ms/downloadazcopy-v10-windows"
$azCopyZip = $managementToolsFolderPath + "azcopy.zip"

$global:currenttime= Set-PSBreakpoint -Variable currenttime -Mode Read -Action {$global:currenttime= Get-Date -UFormat "%A %m/%d/%Y %R"}
$foregroundColor1 = "Red"
$foregroundColor2 = "Yellow"
$writeEmptyLine = "`n"
$writeSeperatorSpaces = " - "

## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

## Check if PowerShell is running as Administrator, otherwise exit the script

$currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
$isAdministrator = $currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if ($isAdministrator -eq $false) {
    Write-Host ($writeEmptyLine + "# Please run PowerShell as Administrator" + $writeSeperatorSpaces + $currentTime)`
    -foregroundcolor $foregroundColor1 $writeEmptyLine
    exit
}
 
## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

## Start script execution

Write-Host ($writeEmptyLine + "# Script started. Without any errors, it will need around 1 minute to complete" + $writeSeperatorSpaces + $currentTime)`
-foregroundcolor $foregroundColor1 $writeEmptyLine 
 
## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

## Create the specfied "management or tools folder" folder if not exists (e.g. Wbin or AdminTools)

If(!(test-path $managementToolsFolderPath))
{
New-Item -Path "C:\" -Name $managementToolsFolderName -ItemType $itemType -Force | Out-Null
}

Write-Host ($writeEmptyLine + "# $managementToolsFolderName folder available under the C: drive" + $writeSeperatorSpaces + $currentTime)`
-foregroundcolor $foregroundColor2 $writeEmptyLine

## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

## Delete AzCopy folder if already exists in $adminToolsFolder folder

If(test-path $azCopyFolder)
{
Remove-Item $azCopyFolder -Recurse | Out-Null
}

Write-Host ($writeEmptyLine + "# $azCopyFolderName folder not available or existing one deleted" + $writeSeperatorSpaces + $currentTime)`
-foregroundcolor $foregroundColor2 $writeEmptyLine
 
## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

## Download, extract and cleanup the latest AzCopy zip file
 
Invoke-WebRequest $azCopyUrl -OutFile $azCopyZip
Expand-Archive -LiteralPath $azCopyZip -DestinationPath $managementToolsFolderPath -Force
Remove-Item $azCopyZip

Write-Host ($writeEmptyLine + "# azcopy.exe available in extracted folder" + $writeSeperatorSpaces + $currentTime)`
-foregroundcolor $foregroundColor2 $writeEmptyLine 
 
## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

## Rename AzCopy version folder to AzCopy

$azCopyOriginalFolderName = Get-ChildItem -Path $managementToolsFolderPath -Name azcopy*
$azCopyFolderToRename = $managementToolsFolderPath + $azCopyOriginalFolderName
$azCopyFolderToRenameTo = $managementToolsFolderPath + $azCopyFolderName

Rename-Item $azCopyFolderToRename $azCopyFolderToRenameTo

Write-Host ($writeEmptyLine + "# $azCopyOriginalFolderName folder renamed to $azCopyFolderName" + $writeSeperatorSpaces + $currentTime)`
-foregroundcolor $foregroundColor2 $writeEmptyLine 
 
## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

## Add the AzCopy folder to the PATH System variable

[Environment]::SetEnvironmentVariable("Path", $env:Path + ";$azCopyFolderToRenameTo", "Machine")

Write-Host ($writeEmptyLine + "# The directory location of the AzCopy executable is added to the system path" + $writeSpace + $writeSeperatorSpaces + $currentTime)`
-foregroundcolor $foregroundColor2 $writeEmptyLine 
 
## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

## Write script completed

Write-Host ($writeEmptyLine + "# Script completed" + $writeSeperatorSpaces + $currentTime)`
-foregroundcolor $foregroundColor1 $writeEmptyLine 

## ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
