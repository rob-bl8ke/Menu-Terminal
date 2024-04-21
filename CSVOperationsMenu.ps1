# Main script

# Import the CsvOperations.ps1 file
. ".\CsvOperations.ps1"

# Function to display operations
function Show-Operations {
    param (
        $record
    )

    $operations = @("Create", "Read", "Update", "Delete")
    $index = 0

    while ($true) {
        Clear-Host
        Write-Host "Use arrow keys to navigate, press Enter to select an operation."
        Write-Host "--------------------------------------------"
        
        for ($i = 0; $i -lt $operations.Count; $i++) {
            if ($i -eq $index) {
                Write-Host ("-> {0}" -f $operations[$i])
            } else {
                Write-Host ("   {0}" -f $operations[$i])
            }
        }

        $key = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown").VirtualKeyCode

        switch ($key) {
            38 { $index = [Math]::Max(0, $index - 1) } # Up arrow
            40 { $index = [Math]::Min(3, $index + 1) } # Down arrow
            13 { 
                if ($operations[$index] -eq "Create") {
                    Create-Record
                } elseif ($operations[$index] -eq "Read") {
                    Read-Records
                } elseif ($operations[$index] -eq "Update") {
                    Update-Record $record
                } elseif ($operations[$index] -eq "Delete") {
                    Delete-Record $record
                }
                return
            } # Enter key
        }
    }
}

# # Start the script
# Show-Operations
