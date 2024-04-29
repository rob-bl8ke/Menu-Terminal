
function New-StubInlineScriptMenuOption {
    param (
        [string]$Text
    )

    return [PSCustomObject]@{
        Description = $Text
        Script = {        
            Write-Host "Executing..."
            if ((Get-YesNo "Would you like to wait for 3 seconds?") -eq $true) {
                Start-Sleep -Milliseconds 3000
            }
            
            Write-Host "... done executing..."
            pause
        }
    }
}

# $Option2 = [PSCustomObject]@{
#     Description = "Option 2: A script file"
#     # A simple script file can be run like this...
#     Script =  Join-Path -Path $ScriptPath -ChildPath "template-scripts\run-once-script.ps1"
# }
