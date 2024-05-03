function Set-SymbolToValue {
    param (
        [string]$Symbol,
        [string]$Value,
        [string]$Blueprint,
        [scriptblock]$Transformation
    )

    # If a transformation script block is provided, invoke it to transform the value
    if ($Transformation) {
        $TransformedValue = & $Transformation $Value
    }
    else {
        $TransformedValue = $Value
    }

    $placeholder = "@{" + $Symbol + "}"

    # Use the Replace method to replace all instances of the symbol with the transformed value
    $Result = $Blueprint.Replace($placeholder, $TransformedValue)

    return $Result
}