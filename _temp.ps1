# CSV file path
$CsvFilePath = ".\files\csv\nums.csv"

# Function to display records
function Show-Records {
    $records = Import-Csv $CsvFilePath
    $index = 0

    while ($true) {
        Clear-Host
        Write-Host "Use arrow keys to navigate, press Enter to select an operation."
        Write-Host "--------------------------------------------"
        
        for ($i = 0; $i -lt $records.Count; $i++) {
            if ($i -eq $index) {
                Write-Host ("-> {0} - {1}" -f $records[$i].No, $records[$i].Description)
            } else {
                Write-Host ("   {0} - {1}" -f $records[$i].No, $records[$i].Description)
            }
        }

        $key = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown").VirtualKeyCode

        switch ($key) {
            38 { $index = [Math]::Max(0, $index - 1) } # Up arrow
            40 { $index = [Math]::Min($records.Count - 1, $index + 1) } # Down arrow
            13 { Show-Operations $records[$index] } # Enter key
        }
    }
}

# Function to display operations
function Show-Operations {
    param (
        $record
    )

    Clear-Host
    Write-Host "Selected Record: $($record.No) - $($record.Description)"
    Write-Host "Choose an operation:"
    Write-Host "1. Create"
    Write-Host "2. Read"
    Write-Host "3. Update"
    Write-Host "4. Delete"

    $choice = Read-Host "Enter operation number"

    switch ($choice) {
        1 { # Create
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
            Read-Host "Press Enter to continue..."
            Show-Records
        }
        2 { # Read
            # Your read script here
            # Refresh records
            Show-Records
        }
        3 { # Update
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
                $records | Export-Csv -Path $CsvFilePath -NoTypeInformation -Force

                Write-Host "Record updated successfully."
            } else {
                Write-Host "This record cannot be updated."
            }
            Read-Host "Press Enter to continue..."
            Show-Records
        }
        4 { # Delete
            if ($record.CanModify -eq "Y") {
                Clear-Host
                Write-Host "Are you sure you want to delete this record?"
                Write-Host "--------------------------------------------"
                Write-Host "No: $($record.No)"
                Write-Host "Description: $($record.Description)"
                $confirm = Read-Host "Confirm deletion of this record? (Y/N)"

                if ($confirm -eq "Y") {
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
            Show-Records
        }
        default {
            Write-Host "Invalid choice"
            Show-Operations $record
        }
    }
}

# Start the script
Show-Records
