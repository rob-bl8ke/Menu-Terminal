# Path to the CSV file
$csvPath = "events.csv"

# Read the CSV file
$data = Import-Csv -Path $csvPath

# Filter out past events
$filteredData = $data | Where-Object { [datetime]::ParseExact($_.Date, 'yyyy-MM-dd', $null) -ge (Get-Date) }

# If no past events are found, inform the user and exit
if ($filteredData.Count -eq $data.Count) {
    Write-Host "No past events found."
    Exit
}

# Export the filtered data back to the CSV file, overwriting the existing file
$filteredData | Export-Csv -Path $csvPath -NoTypeInformation

Write-Host "Past events removed from the CSV file."
