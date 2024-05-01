<#
"Event","Date","Description"
"Prod Support Release","2024-03-06","You are Primary"
"Feature Release","2024-03-16","You are Secondary"
#>

$ScriptPath = Split-Path $MyInvocation.MyCommand.Definition

$dayWindow = 7
$blurbPath = "$ScriptPath\..\..\data\events\events-blurb.txt"
$csvPath = "$ScriptPath\events.csv"

# Read the CSV file
$data = Import-Csv -Path $csvPath

# Filter out past events
$filteredData = $data | Where-Object { [datetime]::ParseExact($_.Date, 'yyyy-MM-dd', $null) -ge (Get-Date) }

# If no future events are found, inform the user and exit
if (-not $filteredData) {
    Set-Location -Path $ScriptPath
    Set-Content -Path $blurbPath -Value "- No upcoming events found for the next $dayWindow days."
    Exit
}

# Sort the filtered data by date
$sortedData = $filteredData | Sort-Object { [datetime]::ParseExact($_.Date, 'yyyy-MM-dd', $null) }

# Retrieve today's date and day of the week
$today = Get-Date
$todayDayOfWeek = $today.DayOfWeek

$eventOutput = @()

# Loop through the sorted data to find events within the x-day window
foreach ($event in $sortedData) {
    $eventDate = [datetime]::ParseExact($event.Date, 'yyyy-MM-dd', $null)
    $daysDifference = ($eventDate - $today).Days + 1
    if ($daysDifference -ge 0 -and $daysDifference -le $dayWindow) {
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
        # Write-Host "- $($event.Event) on $eventDayOfWeekText $eventDaysText. $($event.Description)"
        $eventOutput += "- $($event.Event) on $eventDayOfWeekText $eventDaysText. $($event.Description)"
    }
}

# If no applicable events within the x-day window are found, inform the user
if (-not $sortedData) {
    Set-Location -Path $ScriptPath
    Set-Content -Path $blurbPath -Value "- No upcoming events found for the next $dayWindow days."
}
# Write-Host ""

Set-Content -Path $blurbPath -Value $eventOutput
