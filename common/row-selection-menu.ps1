param (
    [string]$Title,
    [string]$Question,
    [System.Collections.ArrayList]$Options
)

$UP_ARROW = 38
$DOWN_ARROW = 40
$ESCAPE = 27
$ENTER = 13

$highlightWidth = 80
$selectedOption = 0
$ScriptPath = Split-Path $MyInvocation.MyCommand.Definition
.$ScriptPath\prompts.ps1

function Get-AsciiArt {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string]$Title,
        [string]$SubTitle
    )
  
    return @"
  
      $Title
        ~ $SubTitle ~
      _______________
  
  
"@
}
function Get-JsonConfig {
    $jsonContent = Get-Content -Path "$ScriptPath\..\config.json" -Raw
    return $jsonContent | ConvertFrom-Json
}

$config = Get-JsonConfig

$applicationTitle = "(unnamed application)"
if ([string]::IsNullOrWhiteSpace($config.application.title) -eq $false) {
    $applicationTitle = $config.application.title
}

$menuTitle = "(unnamed menu title)"
if ([string]::IsNullOrWhiteSpace($Title) -eq $false) {
    $menuTitle = $Title
}

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
        [string]$Question,
        [string]$AsciiArt,
        [string]$BlurbText
    )
    
    Clear-Host
    
    Write-Host $AsciiArt
    Write-Host $BlurbText
    Write-Host ""
    Write-Host "$Question`n"
    
    for ($i = 0; $i -lt $Options.Count; $i++) {
        if ($i -eq $selectedOption) {
            Write-Host "$($("▶$(" ")$($Options[$i].Description)").PadRight($highlightWidth - 2))" `
                -ForegroundColor White `
        } else {
            Write-Host "$("$("  ")$($Options[$i].Description)")"
        }
    }
}


Try {
    $asciiArt = Get-AsciiArt -Title $applicationTitle -SubTitle $menuTitle
    $blurbText = Get-EventBlurb
    
    Show-Menu -Options $Options -Question $Question -AsciiArt $asciiArt -BlurbText $blurbText
    
    while ($true) {
        $key = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown").VirtualKeyCode
        
        switch ($key) {
            $UP_ARROW {
                if ($selectedOption -gt 0) {
                    $selectedOption--
                }
                Show-Menu -Options $Options -Question $Question -AsciiArt $asciiArt -BlurbText $blurbText
            }
            $DOWN_ARROW {
                if ($selectedOption -lt ($Options.Count - 1)) {
                    $selectedOption++
                }
                Show-Menu -Options $Options -Question $Question -AsciiArt $asciiArt -BlurbText $blurbText
            }
            $ENTER {
                if ($selectedOption -lt 0 -or $selectedOption -ge $Options.Count - 1) {
                    return $null
                }
                return $Options[$selectedOption]
            }
            $ESCAPE {
                return $null
            }
        }
    }
}
Catch {
    $ErrorMessage = $_.Exception.Message
    $ErrorTimestamp = Get-Date
    Add-Content -Path $config.application.errorLogFile -Value "$ErrorTimestamp - $ErrorMessage"

    Throw $_
}
