param (
    [string]$SubTitle,
    [System.Collections.ArrayList]$Options,
    [string]$BlurbText,
    [Object]$Config
)

$UP_ARROW = 38
$DOWN_ARROW = 40
$ESCAPE = 27
$ENTER = 13

$highlightWidth = 80
$selectedOption = 0
$ScriptPath = Split-Path $MyInvocation.MyCommand.Definition
.$ScriptPath\menu-ascii-logo.ps1
.$ScriptPath\prompts.ps1

$menuTitle = "(unnamed) fix config"
if ([string]::IsNullOrWhiteSpace($Config.application.title) -eq $false) {
    $menuTitle = $Config.application.title
}

$menuSubTitle = "(unnamed) pass in '-SubTitle' parameter"
if ([string]::IsNullOrWhiteSpace($SubTitle) -eq $false) {
    Write-Host "got here"
    $menuSubTitle = $SubTitle
}

function Show-Menu {
    param (
        [System.Collections.ArrayList]$Options,
        [string]$Title,
        [string]$BlurbText,
        [string]$SubTitle
    )
    
    Clear-Host
    $image = Show-Ascii -Title $menuTitle -SubTitle $menuSubTitle
    Write-Host $image
    Write-Host $BlurbText
    Write-Host "Choose an option:`n"
    
    for ($i = 0; $i -lt $Options.Count; $i++) {
        if ($i -eq $selectedOption) {
            Write-Host "$($("▶$(" ")$($Options[$i].Description)").PadRight($highlightWidth - 2))" `
                -ForegroundColor White `
        } else {
            Write-Host "$("$("  ")$($Options[$i].Description)")"
        }
    }
}

Show-Menu -Options $Options -Title $menuTitle -SubTitle $menuSubTitle -BlurbText $BlurbText

while ($true) {
    $key = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown").VirtualKeyCode
    
    switch ($key) {
        $UP_ARROW {
            if ($selectedOption -gt 0) {
                $selectedOption--
            }
            Show-Menu -Options $Options -Title $menuTitle -SubTitle $menuSubTitle -BlurbText $BlurbText
        }
        $DOWN_ARROW {
            if ($selectedOption -lt ($Options.Count - 1)) {
                $selectedOption++
            }
            Show-Menu -Options $Options -Title $menuTitle -SubTitle $menuSubTitle -BlurbText $BlurbText
        }
        $ENTER {
            Clear-Host
            $selectedScript = $Options[$selectedOption].Script
            
            if ($selectedScript -is [ScriptBlock]) {
                & $selectedScript
                Show-Menu -Options $Options -Title $menuTitle -SubTitle $menuSubTitle -BlurbText $BlurbText
            } elseif ($selectedScript -is [string]) {
                & $selectedScript
                Show-Menu -Options $Options -Title $menuTitle -SubTitle $menuSubTitle -BlurbText $BlurbText
            } else {
                Write-Host "Unknown script type."
            }
            break
        }
        $ESCAPE {
            exit 0
        }
    }
}