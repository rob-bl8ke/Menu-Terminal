# Create a task

You can categorize your scheduled task by setting the `TaskCategory` parameter when registering the task. This parameter allows you to specify a category for the task, making it easier to find in the Task Manager GUI. Here's how you can modify the PowerShell script to include a category:

You can create a PowerShell script that sets up a scheduled task using the `Register-ScheduledTask` cmdlet. This script will define the task, including the schedule for running it twice a day, and register it in the Task Scheduler. Here's a sample PowerShell script to accomplish this:

```powershell
# Define the name and path of the script to be executed
$scriptPath = "C:\Path\To\Your\Script.ps1"

# Define the name, description, and category of the scheduled task
$taskName = "RunScriptTwiceDaily"
$taskDescription = "Runs the PowerShell script twice a day."
$taskCategory = "CustomTasks"

# Define the trigger for running the task
$trigger1 = New-ScheduledTaskTrigger -Daily -At "09:00" # First run at 9:00 AM
$trigger2 = New-ScheduledTaskTrigger -Daily -At "18:00" # Second run at 6:00 PM

# Define the action to execute the PowerShell script
$action = New-ScheduledTaskAction -Execute "PowerShell.exe" -Argument "-File $scriptPath"

# Register the scheduled task with a specified category
Register-ScheduledTask -TaskName $taskName -Description $taskDescription -TaskCategory $taskCategory -Trigger $trigger1,$trigger2 -Action $action -User "SYSTEM"
```
Replace `"C:\Path\To\Your\Script.ps1"` with the actual path to your PowerShell script.

Here's what this script does:

1. Defines the path to your PowerShell script (`$scriptPath`).
2. Defines the name and description of the scheduled task (`$taskName` and `$taskDescription`).
3. Creates two triggers for running the task: one at 9:00 AM and another at 6:00 PM (`$trigger1` and `$trigger2`).
4. Defines the action to execute the PowerShell script using `PowerShell.exe`.
5. Registers the scheduled task with the specified name, description, triggers, and action.

Run this PowerShell script with administrative privileges, and it will set up a scheduled task in the Task Scheduler to run your script twice a day at the specified times.

The `$taskCategory` variable specifies the category name for your task. You can replace `"CustomTasks"` with any category name you prefer. When you run this script, the scheduled task will be categorized under the specified category in the Task Manager GUI, making it easier to locate.

# Tear down task

Here's a PowerShell script that stops and removes the scheduled task from Task Scheduler:

```powershell
# Define the name of the scheduled task to be stopped and removed
$taskName = "RunScriptTwiceDaily"

# Stop the scheduled task
Stop-ScheduledTask -TaskName $taskName -ErrorAction SilentlyContinue

# Remove the scheduled task
Unregister-ScheduledTask -TaskName $taskName -Confirm:$false
```

This script will:

1. Stop the scheduled task specified by `$taskName` using `Stop-ScheduledTask`.
2. Remove the scheduled task specified by `$taskName` from Task Scheduler using `Unregister-ScheduledTask`.

Ensure that you run this script with administrative privileges. You can run this script whenever you want to stop and remove the scheduled task from Task Scheduler.
