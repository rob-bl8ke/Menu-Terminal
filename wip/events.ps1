# Read the CSV file
$data = Import-Csv -Path "events.csv"

# Initialize variables for earliest and furthest dates
$today = Get-Date
$earliestDate = $today
$furthestDate = $today

# Check for conflicting Primary and Secondary values
$conflictingEntries = $data | Where-Object { $_.Primary -eq "Y" -and $_.Secondary -eq "Y" }
if ($conflictingEntries) {
    Write-Host "Error: Conflicting entries found. A record cannot have 'Y' in both 'Primary' and 'Secondary' columns."
    exit
}

# Loop through each record
foreach ($record in $data) {
    $recordDate = [datetime]::ParseExact($record.Date, "yyyy-MM-dd", $null)

    # Transform event types and output field values
    $eventType = switch ($record.Event) {
        "PS" { "Prod Support Release" }
        "FT" { "Feature Release" }
        Default { $record.Event }
    }

    $primary = switch ($record.Primary) {
        "Y" { "Primary" }
        Default { $record.Primary }
    }

    $secondary = switch ($record.Secondary) {
        "Y" { "Secondary" }
        Default { $record.Secondary }
    }

    # Check if the record date is within the specified range
    if ($recordDate -ge $today -and $recordDate -le $furthestDate.AddDays(14)) {
        # Output the transformed record if it's within the range
        [PSCustomObject]@{
            Event = $eventType
            Primary = $primary
            Secondary = $secondary
            Date = $record.Date
        } | Format-Table -AutoSize
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
