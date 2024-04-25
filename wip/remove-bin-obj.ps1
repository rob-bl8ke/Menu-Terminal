# Define the root folder to start the search
$rootFolder = "C:\Path\To\Root\Folder"

# Function to recursively search and delete bin and obj folders
function Remove-BinObjFolders {
    param (
        [string]$folder
    )

    # Get all subfolders in the current folder
    $subfolders = Get-ChildItem -Path $folder -Directory

    foreach ($subfolder in $subfolders) {
        # Check if the subfolder is named 'bin' or 'obj', and delete it if it is
        if ($subfolder.Name -eq "bin" -or $subfolder.Name -eq "obj") {
            Remove-Item -Path $subfolder.FullName -Recurse -Force
            Write-Host "Removed $($subfolder.FullName)"
        }
        else {
            # Recursively call the function for subfolders
            Remove-BinObjFolders -folder $subfolder.FullName
        }
    }
}

# Call the function with the root folder
Remove-BinObjFolders -folder $rootFolder