# CsvOperations.ps1

# CSV file path
$CsvFilePath = ".\files\csv\nums.csv"

# Function to perform create operation
function Create-Record {
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
}

# Function to perform read operation
function Read-Records {
    # Read script here
    Read-Host "Press Enter to continue..."
}

# Function to perform update operation
function Update-Record {
    param (
        $record
    )

    if ($record.CanModify -eq "Y") {
        do {
            Clear-Host
            Write-Host "Enter new details for the record:"
            Write-Host "---------------------------------"
            $record.Description = Read-Host "New Description"
            $record.CanModify = Read-Host "New CanModify (Y/N)"
            
            Clear-Host
            Write-Host "Updated Record:"
            Write-Host "---------------"
            Write-Host "No: $($record.No)"
            Write-Host "AltNo: $($record.AltNo)"
            Write-Host "Description: $($record.Description)"
            Write-Host "Created: $($record.Created)"
            Write-Host "CanModify: $($record.CanModify)"

            $confirm = Read-Host "Confirm update of this record? (Y/N)"
        } while ($confirm -ne "Y")

        # Update the CSV file
        $records = Import-Csv $CsvFilePath
        $records | Where-Object { $_.No -ne $record.No } | Export-Csv -Path $CsvFilePath -NoTypeInformation
        $record | Export-Csv -Path $CsvFilePath -Append -NoTypeInformation

        Write-Host "Record updated successfully."
    } else {
        Write-Host "This record cannot be updated."
    }
    Read-Host "Press Enter to continue..."
}

# Function to perform delete operation
function Delete-Record {
    param (
        $record
    )

    if ($record.CanModify -eq "Y") {
        Clear-Host
        Write-Host "Are you sure you want to delete this record?"
        Write-Host "--------------------------------------------"
        Write-Host "No: $($record.No)"
        Write-Host "Description: $($record.Description)"
        $confirm = Read-Host "Confirm deletion of this record? (Y/N)"

        if ($confirm -eq "Y") {
            $records = Import-Csv $CsvFilePath
            $records = $records | Where-Object { $_.No -ne $record.No }
            $records | Export-Csv -Path $CsvFilePath -NoTypeInformation -Force
            Write-Host "Record deleted successfully."
        } else {
            Write-Host "Deletion canceled."
        }
    } else {
        Write-Host "This record cannot be deleted."
    }
    Read-Host "Press Enter to continue..."
}
