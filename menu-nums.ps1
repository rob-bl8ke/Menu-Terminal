$ScriptPath = Split-Path $MyInvocation.MyCommand.Definition
$MenuFunctions = "$ScriptPath\menu-function.ps1"

$OptionChange = [PSCustomObject]@{
    Description = "Change num"
    Script = {        
        Write-Host "Changing num..."
        Start-Sleep -Milliseconds 3000
        Write-Host "... done."
        pause
    }
}

$OptionView = [PSCustomObject]@{
    Description = "Viewing Current num"
    Script = {        
        Write-Host "Viewing current num..."
        Start-Sleep -Milliseconds 3000
        Write-Host "Seen enough"?
        pause
    }
}

$OptionManage = [PSCustomObject]@{
    Description = "Manage nums"
    Script =  Join-Path -Path $ScriptPath -ChildPath "menu-nums-manage.ps1"
}

$OptionHistory = [PSCustomObject]@{
    Description = "View num History"
    Script = {        
        Write-Host "Viewing num history..."
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
