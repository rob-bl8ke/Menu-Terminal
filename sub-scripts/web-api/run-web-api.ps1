# Write-Host "Hello"
# # Write-Host "$ScriptPath"
# # Write-Host ""$ScriptPath\..\..\common\stub-menu-option.ps1""
# # Write-Host $Menu
# pause

$ScriptPath = Split-Path $MyInvocation.MyCommand.Definition

$menu = "$ScriptPath\..\..\common\row-selection-menu.ps1"
$csv = "$ScriptPath\gcns.csv"
$data = Import-Csv $csv
$options = @()

$data | ForEach-Object {
    $option = [PSCustomObject]@{
        Value = $_
        Type = "CSV-ROW"
        Description = $_.description
    }
    $options = $options + $option
}

$OptionsInputGcn = [PSCustomObject]@{
    Value = $null
    Type = "INPUT-GCN"
    Description = "Input GCN"
}
$options = $options + $OptionsInputGcn

$OptionQuit = [PSCustomObject]@{
    Value = $null
    Type = "QUIT"
    Description = "Quit"
}

$options = $options + $OptionQuit

$selection = &$menu `
    -Title "GCN Menu" `
    -Question "Please choose a GCN option (or choose Input to manually provide one)" `
    -Options $options

if ($null -ne $selection) {
    if ($selection.Type -eq "CSV-ROW") {
        Clear-Host
        $val = ($data | where-object id -eq "$($selection.Value.id)" | select-object gcn, entityno)
        Write-Host "Running Web API with GCN: $($val.gcn)"
        Start-Sleep -Milliseconds 3000
        Write-Host "... done executing..."
        pause
    } elseif ($selection.Type -eq "INPUT-GCN") {
        Clear-Host
        $val = Read-Host "Please enter a GCN"
        Write-Host "Running Web API with GCN: $($val)"
        Start-Sleep -Milliseconds 3000
        Write-Host "... done executing..."
        pause
    }
}
