# Function to check if a git command exists
function Test-GitInstalled {
    return (Get-Command git -ErrorAction SilentlyContinue) -ne $null
}

# Function to stash changes
function Stash-Changes {
    $stashName = "auto-" + (Get-Date -Format "yyyyMMddHHmmss")
    git stash push -m $stashName
    Write-Host "Changes stashed with ID: $stashName"
}

# Function to prompt user for confirmation
function Confirm-Action {
    param(
        [string]$message
    )

    $choice = Read-Host -Prompt "$message (y/n)"
    if ($choice -eq "y" -or $choice -eq "Y") {
        return $true
    } else {
        return $false
    }
}

# Function to merge main into feature branch
function Merge-MainIntoFeature {
    git merge main
}

# Function to pop stash entry
function Pop-Stash {
    git stash pop
}

# Main function
function Main {
    # Check if git is installed
    if (-not (Test-GitInstalled)) {
        Write-Host "Git is not installed or not in the PATH. Please install Git and try again."
        return
    }

    # Get the currently active branch
    $currentBranch = git rev-parse --abbrev-ref HEAD

    # Check if the current branch is a feature branch
    if ($currentBranch -eq "main") {
        Write-Host "You are on the main branch. Switch to a feature branch to proceed."
        return
    }

    # Check for untracked files, staged files, and modified files
    $untrackedFiles = git ls-files --others --exclude-standard
    $stagedFiles = git diff --cached --name-only
    $modifiedFiles = git ls-files --modified

    # Prompt user to stash changes if any
    if ($untrackedFiles -or $stagedFiles -or $modifiedFiles) {
        Write-Host "Changes detected in the current branch:"
        Write-Host "Untracked files: $($untrackedFiles.Count)"
        Write-Host "Staged files: $($stagedFiles.Count)"
        Write-Host "Modified files: $($modifiedFiles.Count)"

        if (Confirm-Action "Do you want to stash these changes?") {
            Stash-Changes
        } else {
            Write-Host "Cannot proceed without stashing changes. Exiting."
            return
        }
    } else {
        Write-Host "No changes detected in the current branch."
    }

    # Switch to main branch and pull
    git checkout main
    git pull

    # Switch back to feature branch
    git checkout $currentBranch

    # Prompt user to merge main into feature branch
    if (Confirm-Action "Do you want to merge 'main' into the feature branch '$currentBranch'?") {
        # Backup current feature branch
        git branch backup/$currentBranch

        # Merge main into feature branch
        Merge-MainIntoFeature
    }

    # Pop stash entry
    Pop-Stash
}

# Call the main function
Main
