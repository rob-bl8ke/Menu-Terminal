<# ###################################################################################################
The Main Menu
------------------------------------------------------------------------------------------------------

Top level menu


- Look into wt for ways to use other terminal windows
    - https://learn.microsoft.com/en-us/windows/terminal/command-line-arguments?tabs=windows
    - wt ping learn.microsoft.com
################################################################################################### #>

$ScriptPath = Split-Path $MyInvocation.MyCommand.Definition

."$ScriptPath\common\stub-menu-option.ps1"

$Menu = "$ScriptPath\common\operations-menu.ps1"

# $OptionNavigateTo = New-StubInlineScriptMenuOption "Navigate to..."

$OptionNavigateTo = [PSCustomObject]@{
    Description = "Navigate to..."
    Script = {
        Set-Location "C:\Users\robert.blake\Desktop\"
    }
    ExitMenuAfterExecution = $true
}

$OptionGenerate = [PSCustomObject]@{
    Description = "Generate..."
    Script = {
        $menu = Join-Path -Path $ScriptPath -ChildPath ".\..\sub-scripts\generate\menu.ps1"
        & $menu
    }
}

$OptionProjects = [PSCustomObject]@{
    Description = "Projects..."
    Script = {
        $menu = Join-Path -Path $ScriptPath -ChildPath ".\..\sub-scripts\projects\menu.ps1"
        & $menu
    }
}

$OptionRunDiagnostics = [PSCustomObject]@{
    Description = "Run checks"
    Script = {
        $menu = Join-Path -Path $ScriptPath -ChildPath ".\..\sub-scripts\diagnostics\diagnostics.ps1"
        & $menu
    }
}

$OptionQuit = [PSCustomObject]@{
    Description = "Quit"
    Script =  {
        Clear-Host
        exit 0
    }
}

# Pass in the menu sub title, menu options, and configuration to draw and interact with the menu
&$Menu `
    -Title "Main Menu" `
    -Options ([System.Collections.ArrayList]@( `
        $OptionNavigateTo, `
        $OptionGenerate, `
        $OptionProjects, `
        $OptionRunDiagnostics, `
        $OptionQuit `
    ))
