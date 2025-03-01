# .NET Recursive References
Recursively finds all project dependencies in a solution. It runs `dotnet list reference` for each project listed as dependency of the project(s) passed as initial entrypoint(s).

Usage:
```ps1
.\Get-RecursiveReferences.ps1 [-ProjectDirs <paths>] [-h]
```

Parameters:
```
  -ProjectDirs <paths>  Specify the project directories to start the search.
  -ProjectDir <path>    Alias for -ProjectDirs.
  -Silent               Dot not print the visited directories.
  -h                    Display this help message.
  -help                 Alias for -h.
```

Examples:
```ps1
.\Get-RecursiveReferences.ps1 -ProjectDir "C:\path\solution\src\Solution.Api\"
```
```ps1
.\Get-RecursiveReferences.ps1 -ProjectDirs "C:\path\solution\src\Solution.Api\", "C:\path\solution\src\Solution.Infrastructure\"
```