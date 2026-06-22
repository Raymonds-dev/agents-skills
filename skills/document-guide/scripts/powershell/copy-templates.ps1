<#
.SYNOPSIS
    Copia os templates de documentação da Skill para o diretório docs/ de um projeto.
.DESCRIPTION
    Este script copia os templates selecionados (funcional, operacional, tecnica,
    arquitetural e/ou adr) para o diretório docs/ do projeto alvo, preservando
    encoding UTF-8 e permitindo escolher quais templates copiar.
.PARAMETER ProjectPath
    Caminho raiz do projeto de destino. O padrão é o diretório de trabalho atual '.'.
.PARAMETER DocsDir
    Nome do subdiretório de documentação dentro de ProjectPath. O padrão é 'docs'.
.PARAMETER Templates
    Lista dos templates a copiar. Valores aceitos: funcional, operacional, tecnica, arquitetural, adr.
    O padrão é copiar todos os cinco.
.PARAMETER Force
    Se especificado, sobrescreve arquivos existentes sem confirmação.
.EXAMPLE
    # Copiar todos os templates para ./docs/
    powershell -ExecutionPolicy Bypass -File ./scripts/copy-templates.ps1

.EXAMPLE
    # Copiar apenas funcional e ADR para um projeto específico
    powershell -ExecutionPolicy Bypass -File ./scripts/copy-templates.ps1 -ProjectPath "C:\projetos\meu-app" -Templates funcional,adr

.EXAMPLE
    # Sobrescrever arquivos existentes sem confirmação
    powershell -ExecutionPolicy Bypass -File ./scripts/copy-templates.ps1 -Force
#>

param(
    [string]$ProjectPath = ".",
    [string]$DocsDir = "docs",
    [string[]]$Templates = @("funcional", "operacional", "tecnica", "arquitetural", "adr"),
    [switch]$Force
)

# Forçar encoding UTF-8 na saída do console para evitar erros com caracteres especiais
$OutputEncoding = [System.Text.Encoding]::UTF8
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

# ─── Mapeamento: chave amigável → arquivo de template ──────────────────────────
$TemplateMap = @{
    "funcional"    = "funcional-template.md"
    "operacional"  = "operacional-template.md"
    "tecnica"      = "tecnica-template.md"
    "arquitetural" = "arquitetural-template.md"
    "adr"          = "adr-template.md"
}

# ─── Nomes de saída padrão (sem o sufixo -template) ───────────────────────────
$OutputNameMap = @{
    "funcional"    = "funcional.md"
    "operacional"  = "operacional.md"
    "tecnica"      = "tecnica.md"
    "arquitetural" = "arquitetural.md"
    "adr"          = "adr.md"
}

# ─── Caminhos base ─────────────────────────────────────────────────────────────
$TemplatesPath = Join-Path $PSScriptRoot "../../templates"
$ProjectAbsPath = (Resolve-Path $ProjectPath -ErrorAction Stop).Path
$DocsPath = Join-Path $ProjectAbsPath $DocsDir

$CopiedCount = 0
$SkippedCount = 0
$ErrorCount = 0

Write-Host ""
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host " Copiando Templates de Documentação       " -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host " Projeto : $ProjectAbsPath"                -ForegroundColor Gray
Write-Host " Destino : $DocsPath"                     -ForegroundColor Gray
Write-Host " Templates: $($Templates -join ', ')"     -ForegroundColor Gray
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host ""

# ─── Validar pasta de templates da Skill ──────────────────────────────────────
if (-not (Test-Path $TemplatesPath)) {
    Write-Host "❌ [ERRO] Pasta de templates não encontrada: '$TemplatesPath'" -ForegroundColor Red
    exit 1
}

# ─── Criar diretório docs/ se não existir ─────────────────────────────────────
if (-not (Test-Path $DocsPath)) {
    New-Item -ItemType Directory -Path $DocsPath | Out-Null
    Write-Host "📁 Diretório '$DocsDir/' criado em: $DocsPath" -ForegroundColor Yellow
}

# ─── Copiar templates selecionados ────────────────────────────────────────────
foreach ($Key in $Templates) {
    $KeyLower = $Key.ToLower().Trim()

    if (-not $TemplateMap.ContainsKey($KeyLower)) {
        Write-Host "  ⚠️  [AVISO] Template desconhecido: '$Key'. Valores aceitos: $($TemplateMap.Keys -join ', ')" -ForegroundColor Yellow
        $SkippedCount++
        continue
    }

    $SourceFile = Join-Path $TemplatesPath $TemplateMap[$KeyLower]
    $DestFile = Join-Path $DocsPath $OutputNameMap[$KeyLower]

    if (-not (Test-Path $SourceFile)) {
        Write-Host "  ❌ [ERRO] Arquivo de template não encontrado: '$SourceFile'" -ForegroundColor Red
        $ErrorCount++
        continue
    }

    # Verificar se o destino já existe
    if ((Test-Path $DestFile) -and -not $Force) {
        $Answer = Read-Host "  ⚠️  '$($OutputNameMap[$KeyLower])' já existe em docs/. Sobrescrever? (s/N)"
        if ($Answer -notmatch "^[sS]$") {
            Write-Host "  ⏭️  Pulando: $($OutputNameMap[$KeyLower])" -ForegroundColor DarkGray
            $SkippedCount++
            continue
        }
    }

    # Ler com UTF-8 e escrever com UTF-8 (sem BOM) para garantir encoding correto
    $Content = Get-Content -Path $SourceFile -Raw -Encoding UTF8
    [System.IO.File]::WriteAllText($DestFile, $Content, [System.Text.UTF8Encoding]::new($false))

    Write-Host "  ✅ Copiado: $($OutputNameMap[$KeyLower])" -ForegroundColor Green
    $CopiedCount++
}

# ─── Resumo Final ──────────────────────────────────────────────────────────────
Write-Host ""
Write-Host "==========================================" -ForegroundColor Cyan
if ($ErrorCount -eq 0) {
    Write-Host "Concluído! $CopiedCount template(s) copiado(s). $SkippedCount ignorado(s)." -ForegroundColor Green
}
else {
    Write-Host "Concluído com $ErrorCount erro(s). $CopiedCount copiado(s), $SkippedCount ignorado(s)." -ForegroundColor Yellow
}
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host ""

if ($ErrorCount -gt 0) { exit 1 } else { exit 0 }
