param (
    [System.Collections.ArrayList]$Options,
    [string]$AsciiArt,
    [string]$BlurbText,
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

Show-Menu -Options $Options -AsciiArt $AsciiArt -BlurbText $BlurbText

while ($true) {
    $key = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown").VirtualKeyCode
    
    switch ($key) {
        $UP_ARROW {
            if ($selectedOption -gt 0) {
                $selectedOption--
            }
            Show-Menu -Options $Options -AsciiArt $AsciiArt -BlurbText $BlurbText
        }
        $DOWN_ARROW {
            if ($selectedOption -lt ($Options.Count - 1)) {
                $selectedOption++
            }
            Show-Menu -Options $Options -AsciiArt $AsciiArt -BlurbText $BlurbText
        }
        $ENTER {
            Clear-Host
            $selectedScript = $Options[$selectedOption].Script
            
            if ($selectedScript -is [ScriptBlock]) {
                & $selectedScript
                Show-Menu -Options $Options -AsciiArt $AsciiArt -BlurbText $BlurbText
            } elseif ($selectedScript -is [string]) {
                & $selectedScript
                Show-Menu -Options $Options -AsciiArt $AsciiArt -BlurbText $BlurbText
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