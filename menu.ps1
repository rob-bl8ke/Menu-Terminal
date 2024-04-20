$ScriptPath = Split-Path $MyInvocation.MyCommand.Definition
$MenuFunctions = "$ScriptPath\menu-function.ps1"

$Option1 = [PSCustomObject]@{
    Description = "Option 1: Inline"
    Script = {        
        Write-Host "Executing Option 1"
        if ((Get-YesNo "Would you like to wait for 3 seconds?") -eq $true) {
            Start-Sleep -Milliseconds 3000
        }
        
        Write-Host "... done executing..."
        pause
    }
}

$Option2 = [PSCustomObject]@{
    Description = "Option 2: A script file"
    Script =  Join-Path -Path $ScriptPath -ChildPath "template-scripts\run-once-script.ps1"
}

$Option3 = [PSCustomObject]@{
    Description = "Option 3: Inline"
    Script = {
        Write-Host "Executing Option 3"
        if ((Get-YesNo "Would you like to wait for 3 seconds?") -eq $true) {
            Start-Sleep -Milliseconds 3000
        }
        
        Write-Host "... done executing..."
        pause
    }
}

$Option4 = [PSCustomObject]@{
    Description = "Option 4: nums"
    Script =  Join-Path -Path $ScriptPath -ChildPath "menu-nums.ps1"
}

$OptionQuit = [PSCustomObject]@{
    Description = "Quit"
    Script =  {
        exit 0
    }
}

&$MenuFunctions -Options ([System.Collections.ArrayList]@($Option1, $Option2, $Option3, $Option4, $OptionQuit))
