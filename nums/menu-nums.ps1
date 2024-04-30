param (
    [Object]$Config
)

$ScriptPath = Split-Path $MyInvocation.MyCommand.Definition
$Menu = "$ScriptPath\..\common\operations-menu.ps1"

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
    # Script =  Join-Path -Path $ScriptPath -ChildPath ".\manage\menu-nums-manage.ps1"
    Script = {
        # Find the path from "menu-functions.ps1... not the root!
        $menu = Join-Path -Path $ScriptPath -ChildPath ".\..\nums\manage\menu-nums-manage.ps1";
        & $menu -Config $config
    }
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

&$Menu -Title "Nums Sub-menu" -Options ([System.Collections.ArrayList]@($OptionChange, $OptionView, $OptionManage, $OptionHistory, $OptionQuit)) -Config $Config
