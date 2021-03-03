<#
.SYNOPSIS

A script used to download and silently install the latest AzCopy Windows 64-bit executable (.exe) file into the C:\_Admin_Tools\AzCopy folder.

.DESCRIPTION

The latest AzCopy Windows 64-bit executable (.exe) file will be downloaded from a static download link, extracted, and made availabele into the C:\_Admin_Tools\AzCopy folder.
The directory location of the AzCopy executable will also be added to thye system path for ease of use.

.NOTES

Filename:       AzCopy_Download_and_Silent_Installation.ps1
Created:        02/03/21
Last modified:  02/03/21
PowerShell:     5.1
Version:        1.0
Author:         Wim Matthyssen
Twitter:        @wmatthyssen
Action:         Change variables were needed to fit your needs and run as Administrator
Disclaimer:     This script is provided "As IS" with no warranties.

.EXAMPLE

.\AzCopy_Download_and_Silent_Installation.ps1

.LINK

https://tinyurl.com/2x6xxdr3
#>
 
## Variables

$scriptName = "AzCopy_Download_and_Silent_Installation"
$adminToolsFolderName = "_Admin_Tools"
$adminToolsFolder = "C:\" + $adminToolsFolderName +"\"
$itemType = "Directory"
$azCopyFolderName = "AzCopy"
$azCopyFolder = $adminToolsFolder + $azCopyFolderName 
$azCopyUrl = (curl https://aka.ms/downloadazcopy-v10-windows -MaximumRedirection 0 -ErrorAction silentlycontinue).headers.location
$azCopyZip = "azcopy.zip"
$azCopyZipLocation = $adminToolsFolder + $azCopyZip

$writeEmptyLine = "`n"
$writeSeperator = " - "
$writeSpace = " "
$global:currentTime= Set-PSBreakpoint -Variable currenttime -Mode Read -Action {$global:currentTime= Get-Date -UFormat "%A %m/%d/%Y %R"}
$foregroundColor1 = "Red"
$foregroundColor2 = "Yellow"

##-------------------------------------------------------------------------------------------------------------------------------------------------------

## Check if running as Administrator, otherwise close the PowerShell window

$CurrentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
$IsAdministrator = $CurrentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if ($IsAdministrator -eq $false) {
    Write-Host ($writeEmptyLine + "# Please run PowerShell as Administrator" + $writeSeperator + $currentTime)`
    -foregroundcolor $foregroundColor1 $writeEmptyLine
    Start-Sleep -s 5
    exit
}
 
##-------------------------------------------------------------------------------------------------------------------------------------------------------

## Start script execution

Write-Host ($writeEmptyLine + "#" + $writeSpace + $scriptName + $writeSpace + "Script started" + $writeSeperator + $currentTime)`
-foregroundcolor $foregroundColor1 $writeEmptyLine 
 
##-------------------------------------------------------------------------------------------------------------------------------------------------------

## Create C:\_Admin_Tools folder if not exists

If(!(test-path $adminToolsFolder))
{
New-Item -Path "C:\" -Name $adminToolsFolderName -ItemType $itemType -Force | Out-Null
}

Write-Host ($writeEmptyLine + "#" + $writeSpace + $adminToolsFolderName + $writeSpace + "folder available" + $writeSeperator + $currentTime)`
-foregroundcolor $foregroundColor2 $writeEmptyLine
 
##-------------------------------------------------------------------------------------------------------------------------------------------------------

## Delete AzCopy folder if already exists in _Admin_Tools folder

If(test-path $azCopyFolder)
{
Remove-Item $azCopyFolder -Recurse | Out-Null
}

Write-Host ($writeEmptyLine + "#" + $writeSpace + $azCopyFolderName + $writeSpace + "folder not available" + $writeSeperator + $currentTime)`
-foregroundcolor $foregroundColor2 $writeEmptyLine
 
##-------------------------------------------------------------------------------------------------------------------------------------------------------

## Write Download started

Write-Host ($writeEmptyLine + "#" + $writeSpace + $azCopyFolderName + $writeSpace + "download started" + $writeSeperator + $currentTime)`
-foregroundcolor $foregroundColor2 $writeEmptyLine 
 
##-------------------------------------------------------------------------------------------------------------------------------------------------------

## Download, extract and cleanup the latest AzCopy zip file
 
Invoke-WebRequest $azCopyUrl -OutFile $azCopyZipLocation
Expand-Archive -LiteralPath $azCopyZipLocation -DestinationPath $adminToolsFolder -Force
Remove-Item $azCopyZipLocation

Write-Host ($writeEmptyLine + "#" + $writeSpace + "azcopy.exe available" + $writeSeperator + $currentTime)`
-foregroundcolor $foregroundColor2 $writeEmptyLine 
 
##-------------------------------------------------------------------------------------------------------------------------------------------------------

## Rename AzCopy folder

$azCopyOriginalFolderName = Get-ChildItem -Path $adminToolsFolder -Name azcopy*
$azCopyFolderToRename = $adminToolsFolder + $azCopyOriginalFolderName
$azCopyFolderToRenameTo = $adminToolsFolder + $azCopyFolderName

Rename-Item $azCopyFolderToRename $azCopyFolderToRenameTo

Write-Host ($writeEmptyLine + "#" + $writeSpace + "azcopy folder renamed to" + $writeSpace + $azCopyFolderName + $writeSeperator + $currentTime)`
-foregroundcolor $foregroundColor2 $writeEmptyLine 
 
##-------------------------------------------------------------------------------------------------------------------------------------------------------

## Add the AzCopy folder to the Path System Environment Variables

[Environment]::SetEnvironmentVariable("Path", $env:Path + ";$azCopyFolderToRenameTo", "Machine")

Write-Host ($writeEmptyLine + "#" + $writeSpace + "The directory location of the AzCopy executable is added to the system path" + $writeSpace `
+ $writeSeperator + $currentTime) -foregroundcolor $foregroundColor2 $writeEmptyLine 
 
##-------------------------------------------------------------------------------------------------------------------------------------------------------

## Write script completed

Write-Host ($writeEmptyLine + "#" + $writeSpace + "Script completed" + $writeSeperator + $currentTime)`
-foregroundcolor $foregroundColor1 $writeEmptyLine

##-------------------------------------------------------------------------------------------------------------------------------------------------------
