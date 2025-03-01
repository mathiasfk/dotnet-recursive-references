param (
    [string]$ProjectDir = $null
)

$OriginalDir = $(Get-Location)

# If the project directory was provided, change to it
if ($ProjectDir) {
    Set-Location -Path $ProjectDir
}

function Get-RecursiveReferences {
    param (
        [string]$ProjectDir = $null,
        [System.Collections.Generic.List[System.String]]$VisitedPaths,
        [System.Collections.Generic.List[System.String]]$UniqueDependencies
    )
    
    # Initialize the project directory if necessary
    if (-not $ProjectDir) {
        Write-Host "Using current directory as project"
        $ProjectDir = $(Get-Location)
    }

    # List current project references
    $references = dotnet list $ProjectDir reference | Select-String "\.csproj" | ForEach-Object { $_.Line.Trim() }

    # Iterate over current project references
    foreach ($ref in $references) {
        # Resolve the absolute path, handling relative references like ..\..
        $ResolvedPath = Resolve-Path (Join-Path $ProjectDir $ref)

        # Extract the directory from the path, removing the .csproj file
        $FolderPath = Split-Path $ResolvedPath.Path -Parent

        # Check if the directory has already been visited
        if (-not $VisitedPaths.Contains($FolderPath)) {
            # Mark the directory as visited
            $VisitedPaths.Add($FolderPath)

            # Add the dependency to the unique list
            if (-not $UniqueDependencies.Contains($FolderPath)) {
                $UniqueDependencies.Add($FolderPath)
            }

            # Print the directory
            Write-Host "  📂 Visiting: $FolderPath"

            # Change to the directory
            Set-Location -Path $FolderPath

            # Call the function recursively for the current directory
            Get-RecursiveReferences -ProjectDir $FolderPath -VisitedPaths $VisitedPaths -UniqueDependencies $UniqueDependencies

            # Return to the previous directory
            Set-Location -Path $ProjectDir
        } else {
            Write-Host "  🔁 Already visited: $FolderPath"
        }
    }
}

# Initialize the list of dependencies and visited paths outside the function
$VisitedPaths = New-Object 'System.Collections.Generic.List[System.String]'
$UniqueDependencies = New-Object 'System.Collections.Generic.List[System.String]'

# Call the function at the start of the script execution
Get-RecursiveReferences -ProjectDir $ProjectDir -VisitedPaths $VisitedPaths -UniqueDependencies $UniqueDependencies

# Return to the original directory
Set-Location -Path $OriginalDir

# After the complete execution of the recursion, print the unique dependencies
Write-Host "`nUnique dependencies:"
$UniqueDependencies | ForEach-Object { Write-Host "  $_" }