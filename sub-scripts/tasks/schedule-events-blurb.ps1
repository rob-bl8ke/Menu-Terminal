<#
    Description: Task scheduler script to run the script that updates the upcoming event blurbs
#>

$ScriptPath = Split-Path $MyInvocation.MyCommand.Definition

# Define the name and path of the script to be executed
$scriptPath = "$ScriptPath\..\events\events-blurb.ps1"

# Define the name, description, and category of the scheduled task
$taskName = "Update the upcoming events blurb on the main menu"
$taskDescription = "Runs the script multiple times a day to automatically display upcoming events."
$taskCategory = "Robbie\"

# Define the trigger for running the task
$trigger1 = New-ScheduledTaskTrigger -Daily -At "09:15"
$trigger2 = New-ScheduledTaskTrigger -Daily -At "15:35"

# Define the action to execute the PowerShell script
$action = New-ScheduledTaskAction -Execute "PowerShell.exe" -Argument "-File $scriptPath"

# Register the scheduled task with a specified category
Register-ScheduledTask -TaskName $taskName -Description $taskDescription -TaskPath $taskCategory -Trigger $trigger1,$trigger2 -Action $action -User "SYSTEM"