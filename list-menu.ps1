
$ScriptPath = Split-Path $MyInvocation.MyCommand.Definition

$Menu = "$ScriptPath\common\row-selection-menu.ps1"

$Option1  = [PSCustomObject]@{
    Id = "1234"
    Description = "The Option Description"
}

$Option2  = [PSCustomObject]@{
    Id = "2222"
    Description = "The Option Description"
}

$OptionQuit = [PSCustomObject]@{
    Id = "0"
    Description = "quit"
}

# Pass in the menu sub title, menu options, and configuration to draw and interact with the menu
$selection = &$Menu `
    -Title "Main Menu" `
    -Options ([System.Collections.ArrayList]@($Option1, $Option2, $OptionQuit))

    
    if ($selection -eq "0") {
        Write-Host "Just quit the application"
    } else {
        Write-Host "Received: $selection"
    }
