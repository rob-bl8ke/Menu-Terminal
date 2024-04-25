# Read the CSV file
$data = Import-Csv -Path "events.csv"

# Get today's date
$today = Get-Date

# Initialize variables for earliest and furthest dates
$earliestDate = $today
$furthestDate = $today

# Loop through each record
foreach ($record in $data) {
    $recordDate = [datetime]::ParseExact($record.Date, "yyyy-MM-dd", $null)
    
    # Check if the record date is within the specified range
    if ($recordDate -ge $today -and $recordDate -le $furthestDate) {
        # Output the record if it's within the range
        $record | Format-Table -AutoSize
    }
    
    # Update earliest and furthest dates if needed
    if ($recordDate -lt $earliestDate) {
        $earliestDate = $recordDate
    }
    if ($recordDate -gt $furthestDate) {
        $furthestDate = $recordDate
    }
}

# Check if there's old data in the file
if ($earliestDate -lt $today.AddMonths(-2)) {
    Write-Host "Warning: There is a lot of old data in the file that can be removed."
}

# Check if the event list requires more future input
if ($furthestDate -lt $today.AddDays(14)) {
    Write-Host "Warning: The event list requires more future input."
}
