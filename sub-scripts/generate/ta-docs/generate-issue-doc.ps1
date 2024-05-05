
."$PSScriptRoot\..\..\..\common\replacers.ps1"

# Load the filtered data
$filteredData = Import-Csv -Path "$PSScriptRoot\process.csv" | Where-Object { $_.Web -ne "" -or $_.Api -ne "" -or $_.DB -ne "" }

$resultSet = @()

foreach ($item in $filteredData) {
    $obj = [PSCustomObject]@{
        IssueNo = $item.IssueNo
        TaskNo = $item.TaskNo
        DocumentTitle = ""
        FileTitle = ""
        Branch = $item.Branch
        PlatformWebBranchUrlText = ""
        PlatformApiBranchUrlText = ""
        PlatformDatabaseBranchUrlText = ""
    }

    if ([string]::IsNullOrWhiteSpace($item.TaskNo)) {
        $obj.FileTitle = "$($item.IssueNo).md"
        $obj.DocumentTitle = "[$($item.IssueNo) - $($item.IssueDescription)]($($item.IssueUrl))"
    } else {
        $obj.FileTitle = "$($item.IssueNo)-$($item.TaskNo).md"
        $obj.DocumentTitle = "[$($item.IssueNo)($($item.TaskNo)) - $($item.IssueDescription)]($($item.IssueUrl))"
    }

    if ([string]::IsNullOrWhiteSpace($item.Web)) {
        $obj.PlatformWebBranchUrlText = "- [PlatformWeb Branch (Online)]($($item.WebApi))"
    } else {
        $obj.PlatformWebBranchUrlText = "- PlatformWeb (No Online Branch)"
    }
    if ([string]::IsNullOrWhiteSpace($item.Api)) {
        $obj.PlatformApiBranchUrlText = "- [PlatformAPI Branch (Online)]($($item.PlatformApi))"
    } else {
        $obj.PlatformApiBranchUrlText = "- PlatformApi (No Online Branch)"
    }
    if ([string]::IsNullOrWhiteSpace($item.DB)) {
        $obj.PlatformDatabaseBranchUrlText = "- [PlatformDatabase Branch (Online)]($($item.PlatformDatabase))"
    } else {
        $obj.PlatformDatabaseBranchUrlText = "- PlatformDatabase (No Online Branch)"
    }

    $resultSet += $obj
}

# Clear-Host
# # Convert the distinct subset objects to JSON format
# $jsonOutput = $resultSet | ConvertTo-Json

# # Display the JSON structure
# $jsonOutput

$blueprint = Get-Content "$PSScriptRoot\blueprints\issue-doc.md" -Raw

foreach ($item in $resultSet) {
    $output = $blueprint
    
    $output = Set-Value -Symbol "DocumentTitle" -Value $item.DocumentTitle -Blueprint $output
    $output = Set-Value -Symbol "Branch" -Value $item.Branch -Blueprint $output
    $output = Set-Value -Symbol "PlatformWebBranchUrlText" -Value $item.PlatformWebBranchUrlText -Blueprint $output
    $output = Set-Value -Symbol "PlatformApiBranchUrlText" -Value $item.PlatformApiBranchUrlText -Blueprint $output
    $output = Set-Value -Symbol "PlatformDatabaseBranchUrlText" -Value $item.PlatformDatabaseBranchUrlText -Blueprint $output
    
    Set-Content "$PSScriptRoot\$($item.FileTitle)" -Value $output
}
