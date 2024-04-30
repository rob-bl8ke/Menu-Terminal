param (
    [System.Collections.ArrayList]$Options,
    [string]$AsciiArt,
    [Object]$Config
)

Write-Host $AsciiArt

$UP_ARROW = 38
$DOWN_ARROW = 40
$ESCAPE = 27
$ENTER = 13

$highlightWidth = 80
$selectedOption = 0
$ScriptPath = Split-Path $MyInvocation.MyCommand.Definition
.$ScriptPath\prompts.ps1

function Get-EventBlurb {
    $eventBlurbPath = "$ScriptPath\..\data\events\events-blurb.txt"
    if ((Test-Path -Path $eventBlurbPath) -eq $true) {
        return (Get-Content -Path $eventBlurbPath -Raw)
    }
    return "";
}

function Show-Menu {
    param (
        [System.Collections.ArrayList]$Options,
        [string]$AsciiArt,
        [string]$BlurbText
    )
    
    Clear-Host
    
    Write-Host $AsciiArt
    Write-Host $BlurbText
    Write-Host ""
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

Show-Menu -Options $Options -AsciiArt $AsciiArt -BlurbText (Get-EventBlurb)

while ($true) {
    $key = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown").VirtualKeyCode
    
    switch ($key) {
        $UP_ARROW {
            if ($selectedOption -gt 0) {
                $selectedOption--
            }
            Show-Menu -Options $Options -AsciiArt $AsciiArt -BlurbText (Get-EventBlurb)
        }
        $DOWN_ARROW {
            if ($selectedOption -lt ($Options.Count - 1)) {
                $selectedOption++
            }
            Show-Menu -Options $Options -AsciiArt $AsciiArt -BlurbText (Get-EventBlurb)
        }
        $ENTER {
            Clear-Host
            $selectedScript = $Options[$selectedOption].Script
            
            if ($selectedScript -is [ScriptBlock]) {
                & $selectedScript
                Show-Menu -Options $Options -AsciiArt $AsciiArt -BlurbText (Get-EventBlurb)
            } elseif ($selectedScript -is [string]) {
                & $selectedScript
                Show-Menu -Options $Options -AsciiArt $AsciiArt -BlurbText (Get-EventBlurb)
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