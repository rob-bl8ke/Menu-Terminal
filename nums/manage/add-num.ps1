$CsvFilePath = ".\files\csv\nums.csv"

$newRecord = New-Object PSObject -Property @{
    No = ""
    AltNo = ""
    Description = ""
    Created = ""
    CanModify = ""
}

do {
    Clear-Host
    Write-Host "Enter details for the new record:"
    Write-Host "---------------------------------"
    $newRecord.No = Read-Host "No"
    $newRecord.AltNo = Read-Host "AltNo"
    $newRecord.Description = Read-Host "Description"
    $newRecord.Created = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $newRecord.CanModify = Read-Host "CanModify (Y/N)"
    
    Clear-Host
    Write-Host "New Record:"
    Write-Host "-----------"
    Write-Host "No: $($newRecord.No)"
    Write-Host "AltNo: $($newRecord.AltNo)"
    Write-Host "Description: $($newRecord.Description)"
    Write-Host "Created: $($newRecord.Created)"
    Write-Host "CanModify: $($newRecord.CanModify)"

    $confirm = Read-Host "Confirm creation of this record? (Y/N)"
} while ($confirm -ne "Y")

# Append the new record to the CSV file
$newRecord | Export-Csv -Path $CsvFilePath -Append -NoTypeInformation

Write-Host "Record created successfully."