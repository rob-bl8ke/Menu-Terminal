param (
    [System.Collections.ArrayList]$Options
)
    
$UP_ARROW = 38
$DOWN_ARROW = 40
$ESCAPE = 27
$ENTER = 13
$selectedOption = 0
$ScriptPath = Split-Path $MyInvocation.MyCommand.Definition
.$ScriptPath\prompts.ps1

function Show-Menu {
    param (
        [System.Collections.ArrayList]$Options
    )
    
    Clear-Host
    Write-Host "Choose an option:`n"
    
    for ($i = 0; $i -lt $Options.Count; $i++) {
        if ($i -eq $selectedOption) {
            Write-Host "[$($i + 1)] $($Options[$i].Description)" -ForegroundColor Green
        } else {
            Write-Host "$($i + 1) $($Options[$i].Description)"
        }
    }
}

Show-Menu $Options

while ($true) {
    $key = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown").VirtualKeyCode
    
    switch ($key) {
        $UP_ARROW {
            if ($selectedOption -gt 0) {
                $selectedOption--
            }
            Show-Menu $Options
        }
        $DOWN_ARROW {
            if ($selectedOption -lt ($Options.Count - 1)) {
                $selectedOption++
            }
            Show-Menu $Options
        }
        $ENTER {
            Clear-Host
            $selectedScript = $Options[$selectedOption].Script
            
            if ($selectedScript -is [ScriptBlock]) {
                & $selectedScript
                Show-Menu $Options
            } elseif ($selectedScript -is [string]) {
                & $selectedScript
                Show-Menu $Options
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