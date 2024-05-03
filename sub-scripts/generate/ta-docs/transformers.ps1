$ScriptPath = Split-Path $MyInvocation.MyCommand.Definition
."$ScriptPath\..\..\..\common\replace-engine.ps1"

function Set-FeatureBranchForUat {

    param (
        [string] $Symbol,
        [string] $Value,
        [string] $BluePrint
    )
        
    
    # Define a transformation script block
    $RemoveWhitespace = {
        param($Value)
        return $Value -replace '\s+',''
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
        return $Value -replace '\s+',''
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
        return $Value -replace '\s+',''
    }
    
    return Set-SymbolToValue -Symbol $Symbol -Value $Value -Blueprint $Blueprint -Transformation $RemoveWhitespace
}

