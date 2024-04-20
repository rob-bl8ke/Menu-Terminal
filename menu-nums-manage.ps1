$ScriptPath = Split-Path $MyInvocation.MyCommand.Definition
$MenuFunctions = "$ScriptPath\menu-function.ps1"

$OptionList = [PSCustomObject]@{
    Description = "List all nums"
    Script = {        
        Write-Host "Listing all num..."
        Start-Sleep -Milliseconds 3000
        Write-Host "... seen enough?"
        pause
    }
}

$OptionNew = [PSCustomObject]@{
    Description = "New num"
    Script = {        
        Write-Host "Creating a new num..."
        Start-Sleep -Milliseconds 3000
        Write-Host "... done."
        pause
    }
}

$OptionDelete = [PSCustomObject]@{
    Description = "Delete a num"
    Script = {        
        Write-Host "Deleting a new num..."
        Start-Sleep -Milliseconds 3000
        Write-Host "... done."
        pause
    }
}

$OptionQuit = [PSCustomObject]@{
    Description = "Quit"
    Script =  {
        exit 0
    }
}

&$MenuFunctions -Options ([System.Collections.ArrayList]@($OptionList, $OptionNew, $OptionDelete, $OptionQuit))
