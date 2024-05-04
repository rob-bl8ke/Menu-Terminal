<# ###################################################################################################
Generate Menu
------------------------------------------------------------------------------------------------------

All generate operations

################################################################################################### #>

."$PSScriptRoot\..\..\common\stub-menu-option.ps1"
$Menu = "$PSScriptRoot\..\..\common\operations-menu.ps1"

$OptionTechnicalAnalysis = [PSCustomObject]@{
    Description = "Technical Analysis (TA) for Sprint Finalization"
    Script = {
        $generator = Join-Path -Path $PSScriptRoot -ChildPath "\ta-docs\generator.ps1"
        & $generator
    }
}

$OptionTaSequenceDiagram = [PSCustomObject]@{
    Description = "Generate TA Sequence Diagram"
    Script = {
        $generator = Join-Path -Path $PSScriptRoot -ChildPath "\ta-seq-diagram\gen-seq-diagram.ps1"
        & $generator
    }
}

$OptionReleaseNotes = [PSCustomObject]@{
    Description = "Release Notes (Issue tables and log lists)"
    Script = {
        Write-Host "Release Notes (Issue tables and log lists)"
        pause
    }
}

$OptionGlobalSettings = [PSCustomObject]@{
    Description = "Manage Global Settings (Qik)"
    Script = {
        Write-Host "Manage Global Settings (Qik)"
        pause
    }
}

$OptionReleaseBranchInfo = [PSCustomObject]@{
    Description = "Release Branch Info (Qik)"
    Script = {
        Write-Host "Release Branch Info (Qik)"
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
    -Title "Generate (Content) Operations Menu" `
    -Options ([System.Collections.ArrayList]@( `
        $OptionTechnicalAnalysis, `
        $OptionTaSequenceDiagram, `
        $OptionReleaseNotes, `
        $OptionGlobalSettings, `
        $OptionReleaseBranchInfo, `
        $OptionQuit `
    ))
