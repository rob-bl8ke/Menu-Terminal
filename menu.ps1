$ScriptPath = Split-Path $MyInvocation.MyCommand.Definition
$MenuFunctions = "$ScriptPath\common\menu-function.ps1"

."$ScriptPath\common\ascii-logo.ps1"

$jsonContent = Get-Content -Path "config.json" -Raw
$config = $jsonContent | ConvertFrom-Json

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
    if ((Test-Path -Path $eventBlurbPath) -eq $true) {
        return (Get-Content -Path $eventBlurbPath -Raw)
    }
    return "";
}

$menuTitle = "(unnamed) fix config"
if ([string]::IsNullOrWhiteSpace($Config.application.title) -eq $false) {
    $menuTitle = $Config.application.title
}

$SubTitle = "Main Menu"

$menuSubTitle = "(unnamed) pass in '-SubTitle' parameter"
if ([string]::IsNullOrWhiteSpace($SubTitle) -eq $false) {
    Write-Host "got here"
    $menuSubTitle = $SubTitle
}

# Pass in the menu sub title, menu options, and configuration to draw and interact with the menu
&$MenuFunctions `
    -Options ([System.Collections.ArrayList]@($Option1, $Option2, $Option3, $Option4, $OptionQuit)) `
    -AsciiArt (Show-Ascii -Title $menuTitle -SubTitle $menuSubTitle) `
    -BlurbText (Get-EventBlurb) `
    -Config $config
