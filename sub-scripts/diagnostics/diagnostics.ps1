Write-Host "Running diagnostics check..."
Write-Host "Scanning..."

$issues = @()

$jsonPath = "C:\Code\rob-bl8ke\Menu-Terminal\data\diagnostics\secrets.json"
$json = Get-Content -Path $jsonPath | ConvertFrom-Json

if ($null -eq $json.database.connectionString) {
    $issues = $issues + "- Connection string setting does not exist in secrets file."
}
elseif ($json.database.connectionString -eq "[Connection-String]") {
    $issues = $issues + "- Connection string is not set in secrets file."  
}

$settingsPath = "C:\Code\rob-bl8ke\Menu-Terminal\data\diagnostics\settings.xml"
$xml = [xml](Get-Content $settingsPath)

$node = $xml.SelectNodes("//ApplicationManifest/Parameters/Parameter")
# or
# $node = $xml.ApplicationManifest.Parameters.Parameter `
# | Where-Object { $_.Name -eq "Parameter" } | Select-Object -First 1
# or
# $node = $xml.ApplicationManifest.Parameters.Parameter

if ($node.DefaultName -eq "Platform-Key") {
    $issues = $issues + "- Platform-Key placeholder has not been replaced in settings file." 
}

Start-Sleep -Milliseconds 2000
Write-Host "... scanning completed. The following issues have been found:"
Write-Host ""

$issues | Format-Table
Write-Host ""

pause
