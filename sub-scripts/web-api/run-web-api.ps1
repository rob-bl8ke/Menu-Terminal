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
        Id = $_.id
        Description = $_.description
    }
    $options = $options + $option
}

$OptionQuit = [PSCustomObject]@{
    Id = "0"
    Description = "quit"
}

$options = $options + $OptionQuit

$selection = &$menu `
    -Title "Option Selection Menu" `
    -Options $options

if ($selection -eq "0") {
    Write-Host "Just quit the application"
    pause
} else {
    Write-Host "Received: $selection"

    $val = ($data | where-object id -eq "$selection" | select-object gcn, entityno)

    Write-Host "Running Web API with GCN: $($val.gcn)"
    Start-Sleep -Milliseconds 3000
    Write-Host "... done executing..."
    pause
}
