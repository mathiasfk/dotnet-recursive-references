# .NET Recursive References
Recursively finds all project dependencies in a solution. It runs `dotnet list reference` for each project listed as dependency of the project(s) passed as initial entrypoint(s).

In order to run this script you may need to bypass the default system policy to trust it: 
```ps1
Set-ExecutionPolicy Bypass -Scope Process
```

Usage:
```ps1
.\Get-RecursiveReferences.ps1 [-ProjectDirs <paths>] [-h] [-Silent]
```

Parameters:
```
  -ProjectDirs <paths>  Specify the project directories to start the search.
  -ProjectDir <path>    Alias for -ProjectDirs.
  -Silent               Dot not print the visited directories.
  -h                    Display this help message.
  -help                 Alias for -h.
```

## Examples:
```ps1
.\Get-RecursiveReferences.ps1 -ProjectDir "C:\path\solution\src\Solution.Api\"
```
To execute for multiple projects, use a comma after each project:
```ps1
.\Get-RecursiveReferences.ps1 -ProjectDirs "C:\path\solution\src\Solution.Api\", "C:\path\solution\src\Solution.Infrastructure\"
```
You can also break the command into multiple lines:
```ps1
.\Get-RecursiveReferences.ps1 -ProjectDirs `
"C:\path\solution\src\Solution.Api\", `
"C:\path\solution\src\Solution.Infrastructure\"
```
