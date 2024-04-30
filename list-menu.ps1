$ScriptPath = Split-Path $MyInvocation.MyCommand.Definition
$CsvFilePath = "id-table.csv"

$Menu = "$ScriptPath\common\row-selection-menu.ps1"

$data = Import-Csv $CsvFilePath

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

$selection = &$Menu `
    -Title "Option Selection Menu" `
    -Options $options

if ($selection -eq "0") {
    Write-Host "Just quit the application"
} else {
    Write-Host "Received: $selection"
}
