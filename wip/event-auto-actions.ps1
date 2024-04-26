# Set Script Path
$ScriptPath = Split-Path $MyInvocation.MyCommand.Definition

# Define CSV Path
$csvPath = "$ScriptPath\events.csv"

# Read CSV File
$data = Import-Csv -Path $csvPath

# Filter "Prod Support Release" Events
$filteredData = $data | Where-Object { $_.Event -eq "Prod Support Release" }

# Filter out past and future events
$today = Get-Date
$recentPast = $filteredData | Where-Object { [datetime]::ParseExact($_.Date, 'yyyy-MM-dd', $null) -lt $today }
$future = $filteredData | Where-Object { [datetime]::ParseExact($_.Date, 'yyyy-MM-dd', $null) -ge $today }

# Find Closest "Prod Support Release" Events
$closestPast = $recentPast | Sort-Object { [datetime]::ParseExact($_.Date, 'yyyy-MM-dd', $null) } -Descending | Select-Object -First 1
$closestFuture = $future | Sort-Object { [datetime]::ParseExact($_.Date, 'yyyy-MM-dd', $null) } | Select-Object -First 1
$secondClosestFuture = $future | Sort-Object { [datetime]::ParseExact($_.Date, 'yyyy-MM-dd', $null) } | Select-Object -Skip 1 -First 1

# Check if any dates are missing
if (-not $closestPast -or -not $closestFuture -or -not $secondClosestFuture) {
    $errorMessage = "One or more dates not found. Terminating execution. Date and time: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
    Write-Host $errorMessage
    # Log error to errors.log file
    $errorMessage | Out-File -FilePath "$ScriptPath\errors.log" -Append
    Exit
}

# Store Closest "Prod Support Release" Events in Variables
$closestPastDate = $closestPast.Date
$closestFutureDate = $closestFuture.Date
$secondClosestFutureDate = $secondClosestFuture.Date

# Display Results
Write-Host "Closest Past 'Prod Support Release' Date: $closestPastDate"
Write-Host "Closest Future 'Prod Support Release' Date: $closestFutureDate"
Write-Host "Second Closest Future 'Prod Support Release' Date: $secondClosestFutureDate"

# Load XML file
$xmlPath = "$ScriptPath\input.xml"
$xml = [xml](Get-Content $xmlPath)

# Find elements with specified keys and update their values
$xml.projects.globals.input | ForEach-Object {
    if ($_.key -eq "u1") {
        $_.value = $closestFutureDate
    } elseif ($_.key -eq "u2") {
        $_.value = $secondClosestFutureDate
    }
}

# Save the modified XML back to the file
$xml.Save($xmlPath)
