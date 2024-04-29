# Sub-menus will not include this code to get the config from
# the JSON configuration file.
$jsonContent = Get-Content -Path "config.json" -Raw
$config = $jsonContent | ConvertFrom-Json

# .........

# Sub-menues will start here...
$ScriptPath = Split-Path $MyInvocation.MyCommand.Definition
$MenuFunctions = "$ScriptPath\common\menu-function.ps1"

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
    # A simple script file can be run like this...
    Script =  Join-Path -Path $ScriptPath -ChildPath "template-scripts\run-once-script.ps1"
}

$Option3 = [PSCustomObject]@{
    Description = "Option 3: Inline"
    # More advanced menus can be run like this...
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
    # Call a sub-menu by running an inline script.
    # Find the path from "menu-functions.ps1... not the root!
    Script = {
        $menu = Join-Path -Path $ScriptPath -ChildPath ".\..\nums\menu-nums.ps1";
        & $menu -Config $config
    }
}

$OptionQuit = [PSCustomObject]@{
    Description = "Quit"
    Script =  {
        exit 0
    }
}

$eventBlurbPath = "$ScriptPath\data\events\events-blurb.txt"
function Get-EventBlurb {
    $blurb = Get-Content -Path $eventBlurbPath -Raw
    return $blurb
}

# Pass in the menu sub title, menu options, and configuration to draw and interact with the menu
&$MenuFunctions -SubTitle "Main Menu" -Options ([System.Collections.ArrayList]@($Option1, $Option2, $Option3, $Option4, $OptionQuit)) `
-BlurbText (Get-EventBlurb)
-Config $config
