# Read service data from CSV file
$ScriptPath = Split-Path $MyInvocation.MyCommand.Definition
$csvFile = "$ScriptPath\services.csv"
$servicesData = Import-Csv $csvFile

# Construct the $apiServices hashtable from CSV data
$apiServices = @{}
foreach ($service in $servicesData) {
    $apiServices[$service.Key] = @{
        "Name" = $service.Name
        "Class" = $service.Class
        "Participant" = $service.Participant
        "Call" = $service.Call
    }
}

# Display list of service names with their keys
Write-Host ""
Write-Host "Here are a list of services. Type in their desired comma-delimited sequence."
$servicesData | Sort-Object Name | Format-Table Name, Key -AutoSize

# Prompt user to input comma-delimited service keys
$serviceKeysInput = Read-Host "Enter comma-delimited service keys (e.g., LGIG,TASC,ITGA,KC)"

# Convert input to uppercase and split into an array
$serviceKeys = $serviceKeysInput.ToUpper() -split ','

# Function to generate Mermaid sequence diagram script
function Generate-MermaidSequenceDiagram {
    param(
        [string[]]$serviceKeys,
        [hashtable]$apiServices
    )

    # Initialize participant declarations
    $participants = @()

    # Loop through service keys to generate participant declarations
    foreach ($key in $serviceKeys) {
        if ($apiServices.ContainsKey($key)) {
            $serviceData = $apiServices[$key]
            $participants += "$($serviceData['Participant']) $key as <<$($serviceData['Name'])>><br>$($serviceData['Class'])"
        } else {
            # If key doesn't exist in CSV data, use key as name and class, "participant" as participant, "calls" as call
            $participants += "participant $key as <<$key>><br>$key"
        }
    }
    $participants = $participants | Select-Object -Unique

    # Define the Mermaid sequence diagram script header with participant declarations
    $script = @"
sequenceDiagram
autonumber

$($participants -join "`n") `n`n
"@

    # Loop through service keys to generate calls between services
    for ($i = 0; $i -lt $serviceKeys.Length - 1; $i++) {
        $sourceKey = $serviceKeys[$i]
        $targetKey = $serviceKeys[$i + 1]

        if ($apiServices.ContainsKey($sourceKey) -and $apiServices.ContainsKey($targetKey)) {
            $sourceData = $apiServices[$sourceKey]
            $targetData = $apiServices[$targetKey]

            # Add call between services to the script
            $script += @"
${sourceKey} ->> ${targetKey}: $($sourceData['Call'])
Note over ${sourceKey},${targetKey}: A typical interaction `n`n
"@
        } else {
            # If either source or target key doesn't exist, use the keys directly
            $script += @"
${sourceKey} ->> ${targetKey}: calls
Note over ${sourceKey},${targetKey}: A typical interaction `n`n
"@
        }
    }

    # Output the generated Mermaid sequence diagram script
    return $script
}

# Generate Mermaid sequence diagram script
$mermaidScript = Generate-MermaidSequenceDiagram -serviceKeys $serviceKeys -apiServices $apiServices

# Copy the script to clipboard
$mermaidScript | Set-Clipboard

Write-Host "Mermaid script copied to clipboard."

pause
