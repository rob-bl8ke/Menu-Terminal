<# ###################################################################################################
The Main Menu
------------------------------------------------------------------------------------------------------

Top level menu

################################################################################################### #>

$ScriptPath = Split-Path $MyInvocation.MyCommand.Definition

."$ScriptPath\common\stub-menu-option.ps1"

$Menu = "$ScriptPath\common\operations-menu.ps1"

$Option1 = New-StubInlineScriptMenuOption "Menu Option 1"
$Option2 = New-StubInlineScriptMenuOption "Menu Option 2"
$Option3 = New-StubInlineScriptMenuOption "Menu Option 3"

$Option4 = [PSCustomObject]@{
    Description = "Option 4: nums"
    # Call a sub-menu by running an inline script.
    # Find the path from "menu-functions.ps1... not the root!
    Script = {
        $menu = Join-Path -Path $ScriptPath -ChildPath ".\..\nums\menu-nums.ps1";
        & $menu -Config $config
    }
}

$OptionWebApi = [PSCustomObject]@{
    Description = "Web API"
    Script = {
        $menu = Join-Path -Path $ScriptPath -ChildPath ".\..\sub-scripts\web-api\menu.ps1";
        & $menu
    }
}


$OptionQuit = [PSCustomObject]@{
    Description = "Quit"
    Script =  {
        exit 0
    }
}

# Pass in the menu sub title, menu options, and configuration to draw and interact with the menu
&$Menu `
    -Title "Main Menu" `
    -Options ([System.Collections.ArrayList]@( `
        $Option1, `
        $Option2, `
        $Option3, `
        $Option4, `
        $OptionWebApi, `
        $OptionQuit `
    ))
