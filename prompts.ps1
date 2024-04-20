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
