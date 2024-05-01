<# ###################################################################################################
Web API Menu
------------------------------------------------------------------------------------------------------

All operations required by the Web API

################################################################################################### #>
$ScriptPath = Split-Path $MyInvocation.MyCommand.Definition

."$ScriptPath\..\..\common\stub-menu-option.ps1"

$Menu = "$ScriptPath\..\..\\common\operations-menu.ps1"

$OptionRunWebApi = New-StubInlineScriptMenuOption "Run Web Api"
$OptionClearGcnHistory = New-StubInlineScriptMenuOption "Clear GCN History"
$OptionViewCurrentGcn = New-StubInlineScriptMenuOption "View Current GCN"

$OptionQuit = [PSCustomObject]@{
    Description = "Quit"
    Script =  {
        exit 0
    }
}

# Pass in the menu sub title, menu options, and configuration to draw and interact with the menu
&$Menu `
    -Title "Web API" `
    -Options ([System.Collections.ArrayList]@( `
        $OptionRunWebApi, $OptionClearGcnHistory, `
        $OptionViewCurrentGcn, `
        $OptionQuit `
    ))
