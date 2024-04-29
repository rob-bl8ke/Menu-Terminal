<#
    Description: Task scheduler script to run the script that sets the production support release dates to their new values
#>

$ScriptPath = Split-Path $MyInvocation.MyCommand.Definition

# Define the name and path of the script to be executed
$scriptPath = "$ScriptPath\..\release-dates\cycle-next-ps-release-dates.ps1"

# Define the name, description, and category of the scheduled task
$taskName = "Cycle Next Prod Support Release Date Set"
$taskDescription = "Runs the script multiple times a day to automatically move to the next 91 release date cycle."
$taskCategory = "Robbie\"

# Define the trigger for running the task
$trigger1 = New-ScheduledTaskTrigger -Daily -At "07:15"
$trigger2 = New-ScheduledTaskTrigger -Daily -At "09:15"
$trigger3 = New-ScheduledTaskTrigger -Daily -At "15:35"
$trigger4 = New-ScheduledTaskTrigger -Daily -At "19:30"

# Define the action to execute the PowerShell script
$action = New-ScheduledTaskAction -Execute "PowerShell.exe" -Argument "-File $scriptPath"

# Register the scheduled task with a specified category
Register-ScheduledTask -TaskName $taskName -Description $taskDescription -TaskPath $taskCategory -Trigger $trigger1,$trigger2,$trigger3,$trigger4 -Action $action -User "SYSTEM"