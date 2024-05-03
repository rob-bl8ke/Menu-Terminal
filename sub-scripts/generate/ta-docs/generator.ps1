$ScriptPath = Split-Path $MyInvocation.MyCommand.Definition
."$ScriptPath\transformers.ps1"

$jsonPath = "$ScriptPath\..\..\..\config\global-vars.json"
Test-Path $jsonPath

$json = Get-Content $jsonPath | ConvertFrom-Json

# $Value = "34  -  23"
$Blueprint = Get-Content -Path "$ScriptPath\blueprints\1-basic-ta-document.txt" -Raw

Clear-Host
$Blueprint

Write-Host "Generating..."
Write-Host ""
Write-Host "value: " + $json.releaseDates.uat1
Write-Host "---"
$uat1 = $json.releaseDates.uat1

$Blueprint = Set-FeatureBranchForUat -Symbol "%%UAT%%" -Value $uat1 -Blueprint $Blueprint
$Blueprint
$Blueprint = Set-FeatureBranchForUat2 -Symbol "%%UAT2%%" -Value $json.releaseDates.uat2 -Blueprint $Blueprint
$Blueprint
$Blueprint = Set-FeatureBranchForPs -Symbol "%%PS%%" -Value $json.releaseDates.psc -Blueprint $Blueprint
$Blueprint

Write-Host "Done!"

pause