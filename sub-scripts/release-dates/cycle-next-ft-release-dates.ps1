<#
    Description: Move all feature release dates forward in their respective configuration files
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

# Filter "Feature Release" Events
$filteredData = $data | Where-Object { $_.Event -eq "Feature Release" }

# Filter out past and future events
$today = Get-Date
$recentPast = $filteredData | Where-Object { [datetime]::ParseExact($_.Date, 'yyyy-MM-dd', $null) -lt $today }
$future = $filteredData | Where-Object { [datetime]::ParseExact($_.Date, 'yyyy-MM-dd', $null) -ge $today }

# Find Closest "Feature Release" Events
$closestFuture = $future | Sort-Object { [datetime]::ParseExact($_.Date, 'yyyy-MM-dd', $null) } | Select-Object -First 1
$secondClosestFuture = $future | Sort-Object { [datetime]::ParseExact($_.Date, 'yyyy-MM-dd', $null) } | Select-Object -Skip 1 -First 1

# Check if any dates are missing
if ([string]::IsNullOrWhitespace($closestFuture) -or [string]::IsNullOrWhitespace($secondClosestFuture)) {
    $errorMesage = "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') - One or more dates not found. Terminating execution."
    Add-Content -Path $ScriptPath\errors.log -Value $errorMesage
    Exit
}

# Store Closest "Feature Release" Events in Variables
$closestFutureDate = $closestFuture.Date
$secondClosestFutureDate = $secondClosestFuture.Date

# Display Results
Write-Host "Closest Future 'Feature Release' Date: $closestFutureDate"
Write-Host "Second Closest Future 'Feature Release' Date: $secondClosestFutureDate"

# Load XML file
$xml = [xml](Get-Content $xmlPath)

# Find elements with specified keys and update their values
$xml.projects.globals.input | ForEach-Object {
    if ($_.key -eq "uat1") {
        $_.value = $closestFutureDate
    } elseif ($_.key -eq "uat2") {
        $_.value = $secondClosestFutureDate
    }
}

# Save the modified XML back to the file
$xml.Save($xmlPath)

$json = Get-Content $jsonPath | ConvertFrom-Json

# Update values
$json.releaseDates.uat1 = $closestFutureDate
$json.releaseDates.uat2 = $secondClosestFutureDate

# Save the modified JSON back to the file
$json | ConvertTo-Json | Set-Content $jsonPath