To replace values in a JSON file with a similar hierarchical structure, we can use PowerShell to load the JSON file, update the values, and then save the modified JSON back to the file. Here's how you can do it:

Assuming your JSON file looks something like this:

```json
{
  "projects": {
    "globals": {
      "ps": {
        "title": "Release Date (Product Support)",
        "symbol": "PsReleaseDate",
        "value": "2024-04-11"
      },
      "u1": {
        "title": "Release Date (UAT 1)",
        "symbol": "Uat1ReleaseDate",
        "value": "2024-05-04"
      },
      "u2": {
        "title": "Release Date (UAT 2)",
        "symbol": "Uat2ReleaseDate",
        "value": "2024-06-01"
      }
    }
  }
}
```

You can use the following PowerShell script to achieve the desired functionality:

```powershell
# Load JSON file
$jsonPath = "$ScriptPath\input.json"
$json = Get-Content $jsonPath | ConvertFrom-Json

# Update values
$json.projects.globals.u1.value = $closestFutureDate
$json.projects.globals.u2.value = $secondClosestFutureDate

# Save the modified JSON back to the file
$json | ConvertTo-Json | Set-Content $jsonPath
```

This script loads the JSON file, updates the values of the "u1" and "u2" keys with the closest future dates, and then saves the modified JSON back to the file. Make sure to adjust the file path and the structure of the JSON file according to your actual JSON data.