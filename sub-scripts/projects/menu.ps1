<# ###################################################################################################
SPA Operations
------------------------------------------------------------------------------------------------------

All project operations

################################################################################################### #>

."$PSScriptRoot\..\..\common\stub-menu-option.ps1"
$Menu = "$PSScriptRoot\..\..\common\operations-menu.ps1"

$OptionApexSPA = [PSCustomObject]@{
    Description = "Angular App (SPA)"
    Script = {
        Write-Host "Angular App (SPA)"
        pause
    }
}

$OptionWebApi = [PSCustomObject]@{
    Description = "Web API (PlatformWeb)"
    Script = {
        $menu = Join-Path -Path $PSScriptRoot -ChildPath "\web-api\menu.ps1"
        & $menu
    }
}

$OptionPlatformAPI = [PSCustomObject]@{
    Description = "Service Fabric Cluster Services (PlatformAPI)"
    Script = {
        $menu = Join-Path -Path $PSScriptRoot -ChildPath "\platform-api\menu.ps1"
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
        $OptionWebApi, `
        $OptionPlatformAPI, `
        $OptionFunctionsApp, `
        $OptionQuit `
    ))
