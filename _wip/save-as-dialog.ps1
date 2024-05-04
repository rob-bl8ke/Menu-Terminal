# Explicitly load the Windows Forms assembly
Add-Type -AssemblyName System.Windows.Forms

# Open a Save File dialog to save the script
$saveFileDialog = New-Object -TypeName System.Windows.Forms.SaveFileDialog
$saveFileDialog.Filter = "Mermaid Script (*.md)|*.md"
$saveFileDialog.Title = "Save Mermaid Script"
$saveFileDialog.ShowDialog() | Out-Null

# If the user selected a file path, save the script
if ($saveFileDialog.FileName) {
    "Here is some text to save to the file" | Out-File -FilePath $saveFileDialog.FileName -Encoding utf8
    Write-Host "Mermaid script saved to $($saveFileDialog.FileName)"
} else {
    Write-Host "Operation canceled by user."
}
