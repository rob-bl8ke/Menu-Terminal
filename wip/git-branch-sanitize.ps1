$InputString = Read-Host "Please input a work item description"

# Replace special characters with dashes
$sanitizedString = $InputString -replace '[^\w\s-]', ''
# Replace spaces with dashes
$sanitizedString = $sanitizedString -replace '\s', '-'
# Remove consecutive dashes
$sanitizedString = $sanitizedString -replace '-+', '-'
# Trim leading and trailing dashes
$sanitizedString = $sanitizedString.Trim('-').ToLower()
$sanitizedString = $sanitizedString.substring(0, 80)

Write-Host "$InputString transformed to..."
Write-Host $sanitizedString

pause