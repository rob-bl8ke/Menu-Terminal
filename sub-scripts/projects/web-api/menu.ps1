<# ###################################################################################################
Web API Menu
------------------------------------------------------------------------------------------------------

All operations required by the Web API

################################################################################################### #>

$PSScriptRoot = Split-Path $MyInvocation.MyCommand.Definition

."$PSScriptRoot\..\..\..\common\stub-menu-option.ps1"
$Menu = "$PSScriptRoot\..\..\..\common\operations-menu.ps1"

$OptionClearGcnHistory = New-StubInlineScriptMenuOption "Clear GCN History"
$OptionViewCurrentGcn = New-StubInlineScriptMenuOption "View Current GCN"

$OptionRunWebApi = [PSCustomObject]@{
    Description = "Run Web API"
    Script = {
        $menu = Join-Path -Path $PSScriptRoot -ChildPath "\run-web-api.ps1"
        & $menu
    }
}

$OptionQuit = [PSCustomObject]@{
    Description = "Quit"
    Script =  {
        exit 0
    }
}

&$Menu `
    -Title "Web API" `
    -Options ([System.Collections.ArrayList]@( `
        $OptionRunWebApi, `
        $OptionClearGcnHistory, `
        $OptionViewCurrentGcn, `
        $OptionQuit `
    ))
