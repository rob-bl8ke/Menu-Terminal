<#
"Event","Date","Description"
"Prod Support Release","2024-03-06","You are Primary"
"Feature Release","2024-03-16","You are Secondary"
#>

$ScriptPath = Split-Path $MyInvocation.MyCommand.Definition

# Path to the CSV file
$csvPath = "$ScriptPath\events.csv"

# Read the CSV file
$data = Import-Csv -Path $csvPath

# Filter out past events
$filteredData = $data | Where-Object { [datetime]::ParseExact($_.Date, 'yyyy-MM-dd', $null) -ge (Get-Date) }

# If no future events are found, inform the user and exit
if (-not $filteredData) {
    Write-Host "No future events found."
    Exit
}

# Sort the filtered data by date
$sortedData = $filteredData | Sort-Object { [datetime]::ParseExact($_.Date, 'yyyy-MM-dd', $null) }

# Retrieve today's date and day of the week
$today = Get-Date
$todayDayOfWeek = $today.DayOfWeek

# Loop through the sorted data to find events within the 14-day window
foreach ($event in $sortedData) {
    $eventDate = [datetime]::ParseExact($event.Date, 'yyyy-MM-dd', $null)
    $daysDifference = ($eventDate - $today).Days
    if ($daysDifference -ge 0 -and $daysDifference -le 14) {
        # $eventDays = $daysDifference
        if ($daysDifference -eq 0) {
            $eventDaysText = "today"
        }
        elseif ($daysDifference -eq 1) {
            $eventDaysText = "tomorrow"
        }
        else {
            $eventDaysText = "in $daysDifference days time"
        }
        $eventDayOfWeek = $eventDate.DayOfWeek
        $eventDayOfWeekText = $eventDayOfWeek.ToString()
        
        # Output the event description with date transformation
        Write-Host "$($event.Event) on $eventDayOfWeekText $eventDaysText. $($event.Description)"
    }
}

# If no applicable events within the 14-day window are found, inform the user
if (-not $sortedData) {
    Write-Host "No applicable events found within 14 days of today."
}
Write-Host ""

# # Display the results
# Write-Host "Earliest Date: $($filteredData[0].Date)"
# Write-Host "Latest Date: $($filteredData[-1].Date)"
# Write-Host "Today's Date: $($today.ToString('yyyy-MM-dd')) ($todayDayOfWeek)"
