$ScriptPath = Split-Path $MyInvocation.MyCommand.Definition
."$ScriptPath\..\..\..\common\replacers.ps1"
."$ScriptPath\..\..\..\common\get-json-symbol-values.ps1"

$jsonPath = "$ScriptPath\..\..\..\config\global-vars.json"
Test-Path $jsonPath

$json = Get-Content $jsonPath | ConvertFrom-Json

# $Value = "34  -  23"
$Blueprint = Get-Content -Path "$ScriptPath\blueprints\1-basic-ta-document.txt" -Raw

Clear-Host

Write-Host "Generating..."
Write-Host ""

$uat1Setting = "releaseDates.uat1"
$uat2Setting = "releaseDates.uat2"
$pscSetting = "releaseDates.psc"

$uat1 = Get-JsonValue -JsonData $json -Path $uat1Setting
$uat2 = Get-JsonValue -JsonData $json -Path $uat2Setting
$psc = Get-JsonValue -JsonData $json -Path $pscSetting

$Blueprint = Set-FeatureBranchForUat -Symbol $uat1Setting -Value $uat1 -Blueprint $Blueprint
$Blueprint
$Blueprint = Set-FeatureBranchForUat2 -Symbol $uat2Setting -Value $uat2 -Blueprint $Blueprint
$Blueprint
$Blueprint = Set-FeatureBranchForPs -Symbol $pscSetting -Value $psc -Blueprint $Blueprint
$Blueprint

Write-Host "Done!"

pause