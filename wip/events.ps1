# Path to the CSV file
$csvPath = "events.csv"

# Read the CSV file
$data = Import-Csv -Path $csvPath

# Check for "Y" in both Primary and Secondary columns for each row
$conflictingRows = $data | Where-Object { $_.Primary -eq "Y" -and $_.Secondary -eq "Y" }

# If conflicting rows are found, inform the user and output the offending row
if ($conflictingRows.Count -gt 0) {
    Write-Host "Conflict: A 'Y' is present in both Primary and Secondary columns for the following row:"
    $conflictingRows
    Write-Host "Script cannot proceed. Please fix the CSV file and try again."
    Exit
}

# Sort the data by date
$sortedData = $data | Sort-Object { [datetime]::ParseExact($_.Date, 'yyyy-MM-dd', $null) }

# Retrieve today's date and day of the week
$today = Get-Date
# $todayDayOfWeek = $today.DayOfWeek

# Initialize an array to store sentences for applicable events within the 14-day window
$sentences = @()

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
        
        # Replace "PS" with "Prod Support Release" and "FT" with "Feature Release"
        $eventType = switch ($event.Event) {
            "PS" { "Prod Support Release" }
            "FT" { "Feature Release" }
            Default { $event.Event }
        }
        
        # Determine if event is on Primary or Secondary
        $userRole = switch ($event.Primary, $event.Secondary) {
            "Y" { "Primary" }
            Default { "Secondary" }
        }

        $userRole = ""
        if ($event.Primary -eq "Y") { $userRole = "Primary" }
        if ($event.Secondary -eq "Y") { $userRole = "Secondary" }
        
        # Construct sentence
        $sentence = "You have $eventType $eventDayOfWeekText $eventDaysText. You are $userRole."
        $sentences += $sentence
    }
}

# If applicable events within the 14-day window are found, display the sentences
if ($sentences.Count -gt 0) {
    Write-Host ""
    Write-Host ""
    Write-Host "Applicable events within 14 days of today:"
    $sentences
    Write-Host ""
} else {
    Write-Host "No applicable events found within 14 days of today."
}

# # Display the results
# Write-Host "Earliest Date: $($sortedData[0].Date)"
# Write-Host "Latest Date: $($sortedData[-1].Date)"
# Write-Host "Today's Date: $($today.ToString('yyyy-MM-dd')) ($todayDayOfWeek)"
