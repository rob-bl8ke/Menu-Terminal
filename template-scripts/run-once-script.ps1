

$ScriptPath = Split-Path $MyInvocation.MyCommand.Definition
.$ScriptPath\..\prompts.ps1
$FilePath = Join-Path -Path $ScriptPath -ChildPath "template-scripts\run-once-script.ps1"

Write-Host "Executing $FilePath"
if ((Get-YesNo "Would you like to wait for 3 seconds?") -eq $true) {
    Start-Sleep -Milliseconds 3000
}

Write-Host "... done executing..."
pause


