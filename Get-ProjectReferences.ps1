param (
    [string]$ProjectDir = $null
)

$OriginalDir = $(Get-Location)

# Se o diretório do projeto foi informado, muda para ele
if ($ProjectDir) {
    Set-Location -Path $ProjectDir
}

function Get-ProjectReferences {
    param (
        [string]$ProjectDir = $null,
        [System.Collections.Generic.List[System.String]]$VisitedPaths,
        [System.Collections.Generic.List[System.String]]$UniqueDependencies
    )
    
    # Inicializa o diretório de projeto se necessário
    if (-not $ProjectDir) {
        Write-Host "Usando diretório atual como projeto"
        $ProjectDir = $(Get-Location)
    }

    # Lista referências do projeto
    $references = dotnet list $ProjectDir reference | Select-String "\.csproj" | ForEach-Object { $_.Line.Trim() }

    # Resolve os caminhos absolutos das referências
    foreach ($ref in $references) {
        # Resolve o caminho absoluto, tratando referências relativas como ..\..
        $ResolvedPath = Resolve-Path (Join-Path $ProjectDir $ref)

        # Extrai o diretório do caminho, removendo o arquivo .csproj
        $FolderPath = Split-Path $ResolvedPath.Path -Parent

        # Verifica se o diretório já foi visitado
        if (-not $VisitedPaths.Contains($FolderPath)) {
            # Marca o diretório como visitado
            $VisitedPaths.Add($FolderPath)

            # Adiciona a dependência à lista única
            if (-not $UniqueDependencies.Contains($FolderPath)) {
                $UniqueDependencies.Add($FolderPath)
            }

            # Imprime o diretório
            Write-Host "  📂 Visitando: $FolderPath"

            # Faz o 'cd' para o diretório
            Set-Location -Path $FolderPath

            # Chama a função recursivamente para o diretório atual
            Get-ProjectReferences -ProjectDir $FolderPath -VisitedPaths $VisitedPaths -UniqueDependencies $UniqueDependencies

            # Retorna para o diretório anterior
            Set-Location -Path $ProjectDir
        } else {
            Write-Host "  🔁 Já visitado: $FolderPath"
        }
    }
}

# Inicializa a lista de dependências e de caminhos visitados fora da função
$VisitedPaths = New-Object 'System.Collections.Generic.List[System.String]'
$UniqueDependencies = New-Object 'System.Collections.Generic.List[System.String]'

# Chama a função no início da execução do script
Get-ProjectReferences -ProjectDir $ProjectDir -VisitedPaths $VisitedPaths -UniqueDependencies $UniqueDependencies

# Retorna para o diretório original
Set-Location -Path $OriginalDir

# Após a execução completa da recursão, imprime as dependências únicas
Write-Host "`nDependências únicas:"
$UniqueDependencies | ForEach-Object { Write-Host "  $_" }
