<#
.SYNOPSIS
    Gera a estrutura de diretorios de um projeto em formato de arvore Markdown.
.DESCRIPTION
    Percorre recursivamente o caminho informado e imprime no console (e opcionalmente
    salva em arquivo) uma arvore visual no estilo do comando tree, formatada em
    bloco de codigo Markdown. Pastas e arquivos comuns de build/dependencias sao
    ignorados por padrao, mas podem ser reincluidos via -IncludeAll.
.PARAMETER Path
    Caminho raiz a partir do qual mapear a estrutura. Use '.' para o diretorio
    atual, './pasta' para uma subpasta, ou um caminho absoluto.
    Padrao: '.' (diretorio de trabalho atual).
.PARAMETER Output
    Caminho do arquivo de saida (ex: './docs/estrutura.md'). Se nao informado,
    o resultado e exibido apenas no console.
.PARAMETER MaxDepth
    Profundidade maxima de recursao. 0 = sem limite. Padrao: 0.
.PARAMETER IncludeAll
    Se especificado, nao ignora pastas de build/dependencias (node_modules, .git, etc.).
.PARAMETER Append
    Se especificado junto com -Output, anexa ao arquivo existente em vez de sobrescrever.
.EXAMPLE
    # Mapear o projeto inteiro a partir do diretorio atual
    powershell -ExecutionPolicy Bypass -File ./scripts/map-structure.ps1

.EXAMPLE
    # Mapear apenas a pasta docs/ e salvar em docs/estrutura.md
    powershell -ExecutionPolicy Bypass -File ./scripts/map-structure.ps1 -Path ./docs -Output ./docs/estrutura.md

.EXAMPLE
    # Mapear com profundidade maxima de 3 niveis
    powershell -ExecutionPolicy Bypass -File ./scripts/map-structure.ps1 -MaxDepth 3

.EXAMPLE
    # Mapear incluindo node_modules e outras pastas normalmente ignoradas
    powershell -ExecutionPolicy Bypass -File ./scripts/map-structure.ps1 -IncludeAll
#>

param(
    [string]$Path = ".",
    [string]$Output = "",
    [int]   $MaxDepth = 0,
    [switch]$IncludeAll,
    [switch]$Append
)

# Forcalizar encoding UTF-8 na saida do console para evitar erros com caracteres especiais
$OutputEncoding = [System.Text.Encoding]::UTF8
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

# --- Pastas ignoradas por padrao ---
$DefaultIgnore = @(
    "node_modules", ".git", ".svn", ".hg",
    "dist", "build", "out", "bin", "obj",
    ".next", ".nuxt", ".venv", "venv", "__pycache__",
    ".turbo", ".cache", "coverage", ".nyc_output",
    "vendor", "Pods", ".DS_Store"
)

# --- Caracteres da arvore (Unicode box-drawing) ---
$Branch = [char]0x251C  # ├
$Last = [char]0x2514  # └
$Pipe = [char]0x2502  # │
$Dash = [char]0x2500  # ─

$Lines = [System.Collections.Generic.List[string]]::new()

# --- Funcao recursiva de mapeamento ---
function Get-Tree {
    param(
        [string]$DirPath,
        [string]$Prefix,
        [int]   $CurrentDepth
    )

    if ($MaxDepth -gt 0 -and $CurrentDepth -gt $MaxDepth) { return }

    # Obter filhos (pastas primeiro, depois arquivos), ordenados por nome
    $Children = Get-ChildItem -LiteralPath $DirPath -Force | Where-Object {
        if ($IncludeAll) { return $true }
        return ($DefaultIgnore -notcontains $_.Name)
    } | Sort-Object { $_.PSIsContainer -eq $false }, Name

    for ($i = 0; $i -lt $Children.Count; $i++) {
        $Item = $Children[$i]
        $IsLast = ($i -eq ($Children.Count - 1))
        $Connector = if ($IsLast) { "$Last$Dash$Dash " } else { "$Branch$Dash$Dash " }
        $Extension = if ($Item.PSIsContainer) { "/" } else { "" }

        $Lines.Add("$Prefix$Connector$($Item.Name)$Extension")

        if ($Item.PSIsContainer) {
            $NewPrefix = if ($IsLast) { "$Prefix    " } else { "$Prefix$Pipe   " }
            Get-Tree -DirPath $Item.FullName -Prefix $NewPrefix -CurrentDepth ($CurrentDepth + 1)
        }
    }
}

# --- Validar caminho informado ---
if (-not (Test-Path -LiteralPath $Path)) {
    Write-Host "[ERRO] Caminho nao encontrado: '$Path'" -ForegroundColor Red
    exit 1
}

$AbsPath = (Resolve-Path -LiteralPath $Path).Path
$RootName = Split-Path $AbsPath -Leaf
if ([string]::IsNullOrWhiteSpace($RootName)) { $RootName = $AbsPath }

$DepthLabel = if ($MaxDepth -eq 0) { "ilimitada" } else { "$MaxDepth niveis" }
$FilterLabel = if ($IncludeAll) { "nenhum (modo IncludeAll)" } else { ($DefaultIgnore -join ", ") }
$OutLabel = if ($Output) { $Output } else { "(somente console)" }

Write-Host ""
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host " Mapeando Estrutura do Projeto"             -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host " Raiz       : $AbsPath"                     -ForegroundColor Gray
Write-Host " Arquivo    : $OutLabel"                    -ForegroundColor Gray
Write-Host " Profund.   : $DepthLabel"                  -ForegroundColor Gray
Write-Host " Ignorando  : $FilterLabel"                 -ForegroundColor Gray
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host ""

# --- Montar a arvore ---
$Lines.Add("$RootName/")
Get-Tree -DirPath $AbsPath -Prefix "" -CurrentDepth 1

# --- Montar bloco Markdown (3 backticks via [char]96 para evitar erro de parsing) ---
$BT = [char]96   # backtick
$Fence = "$BT$BT$BT"

$TreeBlock = [System.Text.StringBuilder]::new()
[void]$TreeBlock.AppendLine($Fence)
foreach ($L in $Lines) { [void]$TreeBlock.AppendLine($L) }
[void]$TreeBlock.AppendLine($Fence)

$Result = $TreeBlock.ToString()

# --- Exibir no console ---
Write-Host $Result

# --- Salvar em arquivo (se solicitado) ---
if (-not [string]::IsNullOrWhiteSpace($Output)) {
    $OutputAbs = [System.IO.Path]::GetFullPath((Join-Path (Get-Location) $Output))
    $OutputDir = [System.IO.Path]::GetDirectoryName($OutputAbs)

    if (-not (Test-Path $OutputDir)) {
        New-Item -ItemType Directory -Path $OutputDir | Out-Null
        Write-Host "Diretorio criado: $OutputDir" -ForegroundColor Yellow
    }

    if ($Append -and (Test-Path $OutputAbs)) {
        $Existing = [System.IO.File]::ReadAllText($OutputAbs, [System.Text.Encoding]::UTF8)
        [System.IO.File]::WriteAllText(
            $OutputAbs,
            ($Existing + [System.Environment]::NewLine + $Result),
            [System.Text.UTF8Encoding]::new($false)
        )
        Write-Host "Estrutura anexada em: $OutputAbs" -ForegroundColor Green
    }
    else {
        [System.IO.File]::WriteAllText($OutputAbs, $Result, [System.Text.UTF8Encoding]::new($false))
        Write-Host "Estrutura salva em: $OutputAbs" -ForegroundColor Green
    }
}

Write-Host ""
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host " Mapeamento concluido com sucesso"          -ForegroundColor Green
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host ""

exit 0
