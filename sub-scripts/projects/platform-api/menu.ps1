<# ###################################################################################################
Project Operations
------------------------------------------------------------------------------------------------------

All project operations

################################################################################################### #>

$ScriptPath = Split-Path $MyInvocation.MyCommand.Definition

."$ScriptPath\..\..\..\..\common\stub-menu-option.ps1"
$Menu = "$ScriptPath\..\..\..\..\common\operations-menu.ps1"

$OptionCleanBins = [PSCustomObject]@{
    Description = "Clean DLLs (bin and obj folders)"
    Script = {
        Write-Host "Clean DLLs (bin and obj folders)"
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
    -Title "Project Operations Menu" `
    -Options ([System.Collections.ArrayList]@( `
        $OptionCleanBins, `
        $OptionQuit `
    ))
