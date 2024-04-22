$CsvFilePath = ".\files\csv\nums.csv"

# Function to perform create operation
function Create-Record {
    # Load the existing CSV file to determine the column names
    $csv = Import-Csv $CsvFilePath
    
    do {
        $newRecord = New-Object PSObject
    
        foreach ($column in $csv[0].PSObject.Properties | Where-Object { $_.Name -ne "Created" }) {
            $value = Read-Host "Enter $($column.Name)"
            $newRecord | Add-Member -MemberType NoteProperty -Name $column.Name -Value $value
        }
    
        $newRecord | Add-Member -MemberType NoteProperty -Name "Created" -Value (Get-Date -Format "yyyy-MM-dd HH:mm:ss")
        
        Clear-Host
        Write-Host "New Record:"
        Write-Host "-----------"
        foreach ($column in $newRecord.PSObject.Properties) {
            Write-Host "$($column.Name): $($column.Value)"
        }

        $newRecord | Format-List
        $confirm = Read-Host "Confirm creation of this record? (Y/N)"
    } while ($confirm -ne "Y")

    # Append the new record to the CSV file
    $newRecord | Export-Csv -Path $CsvFilePath -Append -NoTypeInformation

    Write-Host "Record created successfully."
}

# Function to perform update operation
function Update-Record {
    param (
        $record
    )

    do {
        Clear-Host
        Write-Host "Updated Record:"
        Write-Host "---------------"
        foreach ($column in $record.PSObject.Properties | Where-Object { $_.Name -ne "Created" }) {
            $value = Read-Host "Enter $($column.Name) (Current: $($column.Value))"
            $record | Add-Member -MemberType NoteProperty -Name $column.Name -Value $value -Force
        }

        # foreach ($column in $record.PSObject.Properties) {
        #     Write-Host "$($column.Name): $($column.Value)"
        # }
        $record | Format-List

        $confirm = Read-Host "Confirm update of this record? (Y/N)"
    } while ($confirm -ne "Y")

    # Update the CSV file
    $records = Import-Csv $CsvFilePath
    $records | Where-Object { $_.No -ne $record.No } | Export-Csv -Path $CsvFilePath -NoTypeInformation
    $record | Export-Csv -Path $CsvFilePath -Append -NoTypeInformation

    Write-Host "Record updated successfully."
}

# Create-Record
Update-Record (Import-Csv $CsvFilePath)[0]