<# ###################################################################################################
SPA Operations
------------------------------------------------------------------------------------------------------

All project operations

################################################################################################### #>

$ScriptPath = Split-Path $MyInvocation.MyCommand.Definition

."$ScriptPath\..\..\..\common\stub-menu-option.ps1"
$Menu = "$ScriptPath\..\..\..\common\operations-menu.ps1"

$OptionApexSPA = [PSCustomObject]@{
    Description = "Angular App (SPA)"
    Script = {
        Write-Host "Angular App (SPA)"
        pause
    }
}

$OptionPlatformWeb = [PSCustomObject]@{
    Description = "Web API (PlatformWeb)"
    Script = {
        Write-Host "Web API (PlatformWeb)"
        pause
    }
}

$OptionPlatformAPI = [PSCustomObject]@{
    Description = "Service Fabric Cluster Services (PlatformAPI)"
    Script = {
        $menu = Join-Path -Path $ScriptPath -ChildPath ".\..\sub-scripts\sub-menus\projects\platform-api\menu.ps1"
        & $menu
    }
}

$OptionFunctionsApp = [PSCustomObject]@{
    Description = "FunctionsApp"
    Script = {
        Write-Host "FunctionsApp"
        pause
    }
}
$OptionQuit = [PSCustomObject]@{
    Description = "Quit"
    Script =  {
        exit 0
    }
}

&$Menu `
    -Title "SPA Operations Menu" `
    -Options ([System.Collections.ArrayList]@( `
        $OptionApexSPA, `
        $OptionPlatformWeb, `
        $OptionPlatformAPI, `
        $OptionFunctionsApp, `
        $OptionQuit `
    ))
