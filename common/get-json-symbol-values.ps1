function Get-JsonValue {
    param (
        [object]$JsonData,
        [string]$Path
    )

    # Split the path into individual property names
    $pathParts = $Path -split '\.'

    # Traverse the JSON object based on the path
    $currentObject = $JsonData
    foreach ($part in $pathParts) {
        $currentObject = $currentObject.$part
        if ($currentObject -eq $null) {
            return $null  # Property not found, return null
        }
    }

    return $currentObject
}
