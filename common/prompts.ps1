function Get-YesNo() {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string]$promptText
    )

    $confirmation = Read-Host "$promptText (y/n)"
    if ($confirmation -eq 'y') {
        return $true
    }
    elseif ($confirmation -eq 'Y') {
        return $true
    }
    elseif ($confirmation -eq 'n') {
        return $false
    }
    elseif ($confirmation -eq 'N') {
        return $false
    }
    else {
        return $false
    }
}

function Write-File {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string]$FileName,
        [string]$FileContent,
        [string]$FilesFilter,
        [string]$DialogTitle = "Save as Dialog"


    )
    # Explicitly load the Windows Forms assembly
    Add-Type -AssemblyName System.Windows.Forms

    Write-Host "Opening save dialog (may open in the background...)"

    # Open a Save File dialog to save the script
    $saveFileDialog = New-Object -TypeName System.Windows.Forms.SaveFileDialog
    $saveFileDialog.Filter = $filesFilter
    $saveFileDialog.Title = $dialogTitle
    $saveFileDialog.FileName = $fileName
    $saveFileDialog.ShowDialog() | Out-Null

    # If the user selected a file path, save the script
    if ($saveFileDialog.FileName) {
        $fileContent | Out-File -FilePath $saveFileDialog.FileName -Encoding utf8
        Write-Host "File saved to $($saveFileDialog.FileName)"
    } else {
        Write-Host "File save operation canceled."
    }
}