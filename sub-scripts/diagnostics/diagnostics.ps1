Write-Host "Running diagnostics check..."
Write-Host "Scanning..."
Start-Sleep -Milliseconds 10000
Write-Host "... scanning completed. The following issues have been found:"
Write-Host "- FunctionsApp does not seem to have been configured."
Write-Host "- Customer Service config does not seem to have been configured."
Write-Host "- Service Fabric not started."
pause