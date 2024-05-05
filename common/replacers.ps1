."$PSScriptRoot\replace-engine.ps1"

# Simply replace the value. Do not transform.
function Set-Value {
    param (
        [string] $Symbol,
        [string] $Value,
        [string] $BluePrint
    )
    
    return Set-SymbolToValue -Symbol $Symbol -Value $Value -Blueprint $Blueprint -Transformation $null
}

function Set-FeatureBranchForUat {

    param (
        [string] $Symbol,
        [string] $Value,
        [string] $BluePrint
    )

    # Define a transformation script block
    $RemoveWhitespace = {
        param($Value)
        return "rc/$Value"
    }
    
    return Set-SymbolToValue -Symbol $Symbol -Value $Value -Blueprint $Blueprint -Transformation $RemoveWhitespace
}
function Set-FeatureBranchForUat2 {

    param (
        [string] $Symbol,
        [string] $Value,
        [string] $BluePrint
    )
        
    
    # Define a transformation script block
    $RemoveWhitespace = {
        param($Value)
        return "rc-next/$Value"
    }
    
    return Set-SymbolToValue -Symbol $Symbol -Value $Value -Blueprint $Blueprint -Transformation $RemoveWhitespace
}
function Set-FeatureBranchForPs {

    param (
        [string] $Symbol,
        [string] $Value,
        [string] $BluePrint
    )
        
    
    # Define a transformation script block
    $RemoveWhitespace = {
        param($Value)
        return "hotfix/$Value"
    }
    
    return Set-SymbolToValue -Symbol $Symbol -Value $Value -Blueprint $Blueprint -Transformation $RemoveWhitespace
}
