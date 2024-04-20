$ScriptPath = Split-Path $MyInvocation.MyCommand.Definition
$MenuFunctions = "$ScriptPath\menu-function.ps1"

$OptionChange = [PSCustomObject]@{
    Description = "Change GCN"
    Script = {        
        Write-Host "Changing GCN..."
        Start-Sleep -Milliseconds 3000
        Write-Host "... done."
        pause
    }
}

$OptionView = [PSCustomObject]@{
    Description = "Viewing Current GCN"
    Script = {        
        Write-Host "Viewing current GCN..."
        Start-Sleep -Milliseconds 3000
        Write-Host "Seen enough"?
        pause
    }
}

$OptionManage = [PSCustomObject]@{
    Description = "Manage GCNs"
    Script = {        
        Write-Host "Managing GCNs"
        Start-Sleep -Milliseconds 3000
        Write-Host "Done enough"?
        pause
    }
}

$OptionHistory = [PSCustomObject]@{
    Description = "View GCN History"
    Script = {        
        Write-Host "Viewing GCN history..."
        Start-Sleep -Milliseconds 3000
        Write-Host "Seen enough"?
        pause
    }
}

$OptionQuit = [PSCustomObject]@{
    Description = "Quit"
    Script =  {
        exit 0
    }
}

&$MenuFunctions -Options ([System.Collections.ArrayList]@($OptionChange, $OptionView, $OptionManage, $OptionHistory, $OptionQuit))
