param (
    [Object]$Config
)

$ScriptPath = Split-Path $MyInvocation.MyCommand.Definition
$MenuFunctions = "$ScriptPath\..\..\common\menu-function.ps1"

$csvFilePath = ".\files\csv\nums.csv"
$records = Import-Csv $csvFilePath
$CsvRowOptions = New-Object System.Collections.Generic.List[System.Object]

# Problem here is that the script block will always hold a reference
# to the last supplied $curRecord which is the last record in the CSV
# Once the iteration completes it seems that only one script block is
# held in memory and it remembers the last record bound to it via the
# param.
foreach ($record in $records) {
    $desc = "$($record.No) - $($record.Description)"
    $curRecord = $record
    $recordOption = [PSCustomObject]@{
        Description = $desc
        Script = {        
            param($curRecord)  # Define a parameter to pass the current record
            Write-Host "You selected $($record.No) - $($record.Description)"
            Start-Sleep -Milliseconds 3000
            Write-Host "... seen enough?"
            pause
        }
    }
    $CsvRowOptions.Add($recordOption)
}

# Write-Host $CsvRowOptions[0].Description
# $selectedScript = $CsvRowOptions[0].Script
# & $selectedScript
# $CsvRowOptions | Format-Table
pause

$OptionList = [PSCustomObject]@{
    Description = "List all nums"
    Script = {        
        Write-Host "Listing all num..."
        Start-Sleep -Milliseconds 3000
        Write-Host "... seen enough?"
        pause
    }
}

$OptionNew = [PSCustomObject]@{
    Description = "New num"
    Script = {        
        Write-Host "Creating a new num..."
        Start-Sleep -Milliseconds 3000
        Write-Host "... done."
        pause
    }
}

$OptionDelete = [PSCustomObject]@{
    Description = "Delete a num"
    Script = {        
        Write-Host "Deleting a new num..."
        Start-Sleep -Milliseconds 3000
        Write-Host "... done."
        pause
    }
}

$OptionQuit = [PSCustomObject]@{
    Description = "Quit"
    Script =  {
        exit 0
    }
}

&$MenuFunctions -SubTitle "Nums Management" -Options ($CsvRowOptions + ([System.Collections.ArrayList]@($OptionList, $OptionNew, $OptionDelete, $OptionQuit))) -Config $Config
