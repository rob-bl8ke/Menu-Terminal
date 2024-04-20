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

$selectedOption = 0

$Option1 = [PSCustomObject]@{
    Description = "Option 1: Run script 1"
    Script = {
        Write-Host "Script 1 executed."
        # Your script 1 logic here
    }
}

$Option2 = [PSCustomObject]@{
    Description = "Option 2: Run script 2"
    Script = "C:\Scripts\Script2.ps1"
}

$Option3 = [PSCustomObject]@{
    Description = "Option 3: Run script 3"
    Script = {
        Write-Host "Script 3 executed."
        # Your script 3 logic here
    }
}

$Options = [System.Collections.ArrayList]@($Option1, $Option2, $Option3)

Show-Menu $Options

while ($true) {
    $key = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown").VirtualKeyCode

    switch ($key) {
        38 { # Up arrow key
            if ($selectedOption -gt 0) {
                $selectedOption--
            }
            Show-Menu $Options
        }
        40 { # Down arrow key
            if ($selectedOption -lt ($Options.Count - 1)) {
                $selectedOption++
            }
            Show-Menu $Options
        }
        13 { # Enter key
            Clear-Host
            $selectedScript = $Options[$selectedOption].Script
            Write-Host "You selected: $($Options[$selectedOption].Description)"
            if ($selectedScript -is [ScriptBlock]) {
                Write-Host "Executing script code."
                & $selectedScript
            } elseif ($selectedScript -is [string]) {
                Write-Host "Executing script file: $selectedScript"
                & $selectedScript
            } else {
                Write-Host "Unknown script type."
            }
            break
        }
    }
}