<#
    Description: Move all production support release dates forward in their respective configuration files
    Reason: Set environment up for the next release and ready system for up to date document generate processes.
#>

# Set Script Path
$ScriptPath = Split-Path $MyInvocation.MyCommand.Definition

# Define CSV Path
$csvPath = "$ScriptPath\..\..\data\events\events.csv"
$xmlPath = "$ScriptPath\..\..\config\qik-config.xml"
$jsonPath = "$ScriptPath\..\..\config\global-vars.json"

# Read CSV File
$data = Import-Csv -Path $csvPath

# Filter "Prod Support Release" Events
$filteredData = $data | Where-Object { $_.Event -eq "Prod Support Release" }

# Filter out past and future events
$today = Get-Date
$recentPast = $filteredData | Where-Object { [datetime]::ParseExact($_.Date, 'yyyy-MM-dd', $null) -lt $today.AddDays(-1) }
$future = $filteredData | Where-Object { [datetime]::ParseExact($_.Date, 'yyyy-MM-dd', $null) -ge $today }

# Find Closest "Prod Support Release" Events
$closestPast = $recentPast | Sort-Object { [datetime]::ParseExact($_.Date, 'yyyy-MM-dd', $null) } -Descending | Select-Object -First 1
$closestFuture = $future | Sort-Object { [datetime]::ParseExact($_.Date, 'yyyy-MM-dd', $null) } | Select-Object -First 1

# Check if any dates are missing
if ([string]::IsNullOrWhitespace($closestPast) -or [string]::IsNullOrWhitespace($closestFuture)) {
    $errorMesage = "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') - One or more dates not found. Terminating execution."
    Add-Content -Path $ScriptPath\errors.log -Value $errorMesage
    Exit
}

# Store Closest "Prod Support Release" Events in Variables
$closestPastDate = $closestPast.Date
$closestFutureDate = $closestFuture.Date

# Display Results
Write-Host "Closest Past 'Prod Support Release' Date: $closestPastDate"
Write-Host "Closest Future 'Prod Support Release' Date: $closestFutureDate"

# Load XML file
$xml = [xml](Get-Content $xmlPath)

# Find elements with specified keys and update their values
$xml.projects.globals.input | ForEach-Object {
    if ($_.key -eq "psp") {
        $_.value = $closestPastDate
    } elseif ($_.key -eq "psc") {
        $_.value = $closestFutureDate 
    }
}

# Save the modified XML back to the file
$xml.Save($xmlPath)

$json = Get-Content $jsonPath | ConvertFrom-Json

# Update values
$json.releaseDates.psp = $closestPastDate
$json.releaseDates.psc = $closestFutureDate
# $json.releaseDates.uat1 = $closestFutureDate
# $json.releaseDates.uat2 = $closestFutureDate

# Save the modified JSON back to the file
$json | ConvertTo-Json | Set-Content $jsonPath