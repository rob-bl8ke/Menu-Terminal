# You'll probably need a parent menu above this that has a "List Recs" and "Create Rec" Example.

# CSV file path
$CsvFilePath = ".\files\csv\nums.csv"

. ".\CsvOperationsMenu.ps1"

# Function to display records
function Show-Records {
    $records = Import-Csv $CsvFilePath
    $index = 0

    while ($true) {
        Clear-Host
        Write-Host "Use arrow keys to navigate, press Enter to select an operation."
        Write-Host "Use the escape key to go back"
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
            # Can use the escape key here to move back...
        }
    }
}

# Start the script
Show-Records
