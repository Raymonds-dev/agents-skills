<#
.SYNOPSIS
    Audita a integridade e preenchimento da documentação Markdown com base nos templates da Skill.
.DESCRIPTION
    Este script verifica:
    1. Se as seções obrigatórias (definidas entre comentários HTML) foram preenchidas.
    2. Se as seções opcionais contêm texto padrão do template (o que exige preenchimento ou remoção).
    3. Se há links markdown relativos quebrados.
.PARAMETER Path
    Diretório contendo a documentação a ser auditada. O padrão é o diretório atual '.'.
#>

param(
    [string]$Path = "."
)

# Forçar encoding UTF-8 na saída do console para evitar erros com caracteres especiais
$OutputEncoding = [System.Text.Encoding]::UTF8
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

$ErrorCount = 0
$WarningCount = 0

Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "Iniciando Auditoria de Documentação (Comentários de Controle)" -ForegroundColor Cyan
Write-Host "Diretório de busca: (Procurando em $Path)" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan

# 1. Localizar Diretório de Templates
$TemplatesPath = Join-Path $PSScriptRoot "../../templates"
if (-not (Test-Path $TemplatesPath)) {
    Write-Error "Pasta de templates não encontrada em '$TemplatesPath'."
    exit 1
}

# 2. Carregar e Parsear Templates para Biblioteca de Validação
$TemplateLibrary = @{}
$TemplateFiles = Get-ChildItem -Path $TemplatesPath -Filter "*-template.md"

foreach ($TmplFile in $TemplateFiles) {
    $TmplText = Get-Content -Path $TmplFile.FullName -Raw -Encoding UTF8
    
    # Identificar a tag <!-- TEMPLATE: nome -->
    if ($TmplText -match '<!-- TEMPLATE:\s*(\w+)\s*-->') {
        $TmplName = $Matches[1]
        $TemplateLibrary[$TmplName] = @{}
        
        # Encontrar todas as seções demarcadas com <!-- INICIO:SECAO (TIPO) --> ... <!-- FIM:SECAO -->
        # regex multiline (?s) para capturar quebras de linha no conteúdo
        $SectionRegex = "(?s)<!-- INICIO:(\w+)(?:\s+\((OBRIGATÓRIO|OPCIONAL)\))?\s*-->\s*(.*?)\s*<!-- FIM:\1 -->"
        $MatchesList = [regex]::Matches($TmplText, $SectionRegex)
        
        foreach ($Match in $MatchesList) {
            $SecID = $Match.Groups[1].Value
            $SecType = $Match.Groups[2].Value
            $SecContent = $Match.Groups[3].Value.Trim()
            
            if ([string]::IsNullOrEmpty($SecType)) { $SecType = "OPCIONAL" }
            
            $TemplateLibrary[$TmplName][$SecID] = @{
                Content = $SecContent
                Type    = $SecType
            }
        }
    }
}

# 3. Localizar Arquivos de Documentação no Projeto
if (-not (Test-Path $Path)) {
    Write-Error "O caminho '$Path' não foi encontrado."
    exit 1
}

# Busca recursiva de arquivos .md ignorando pastas comuns de build/dependências
$AbsSearchPath = (Resolve-Path $Path).Path
$MdFiles = Get-ChildItem -Path $Path -Filter "*.md" -Recurse | Where-Object {
    $RelativePath = $_.FullName.Substring($AbsSearchPath.Length)
    $RelativePath -notmatch "node_modules|\\\.git|\\\.github|\\\.agents|\\\.gemini|\\brain|\\templates|\\references|\\scripts"
}

if ($MdFiles.Count -eq 0) {
    Write-Host "Nenhum arquivo markdown (.md) encontrado para auditoria." -ForegroundColor Yellow
    exit 0
}

# 4. Validar os arquivos em relação aos templates
foreach ($File in $MdFiles) {
    $FileText = Get-Content -Path $File.FullName -Raw -Encoding UTF8
    $FileDir = $File.DirectoryName
    
    # Verificar se o arquivo declara qual template ele utiliza (ex: <!-- TEMPLATE: funcional -->)
    if ($FileText -match '<!-- TEMPLATE:\s*(\w+)\s*-->') {
        $UsedTmpl = $Matches[1]
        
        if (-not $TemplateLibrary.ContainsKey($UsedTmpl)) {
            Write-Host "⚠️ [AVISO] O arquivo '$($File.Name)' declara o template '$UsedTmpl', que não está registrado na biblioteca." -ForegroundColor Yellow
            $WarningCount++
            continue
        }
        
        Write-Host "`nAnalisando Documento: $($File.FullName)" -ForegroundColor Blue
        Write-Host "Template Declarado: $UsedTmpl" -ForegroundColor Gray
        
        $TmplSections = $TemplateLibrary[$UsedTmpl]
        
        # Iterar sobre todas as seções definidas para o template
        foreach ($SecKey in $TmplSections.Keys) {
            $SecData = $TmplSections[$SecKey]
            $SecType = $SecData.Type
            $SecDefaultContent = $SecData.Content
            
            # Procurar a seção correspondente no arquivo do usuário
            $UserSecRegex = "(?s)<!-- INICIO:$SecKey(?:\s+\((OBRIGATÓRIO|OPCIONAL)\))?\s*-->\s*(.*?)\s*<!-- FIM:$SecKey -->"
            
            if ($FileText -match $UserSecRegex) {
                $UserContent = $Matches[2].Trim()
                
                # Caso o conteúdo do usuário seja idêntico ao do template original ou esteja vazio
                if ($UserContent -eq $SecDefaultContent -or [string]::IsNullOrWhiteSpace($UserContent)) {
                    if ($SecType -eq "OBRIGATÓRIO") {
                        Write-Host "  ❌ [ERRO] Seção OBRIGATÓRIA '$SecKey' não foi preenchida." -ForegroundColor Red
                        $ErrorCount++
                    }
                    else {
                        Write-Host "  ❌ [ERRO] Seção OPCIONAL '$SecKey' não foi preenchida nem removida do arquivo." -ForegroundColor Red
                        Write-Host "            (Dica: se não for utilizar a seção, apague todo o bloco, inclusive os comentários de INICIO/FIM)." -ForegroundColor Gray
                        $ErrorCount++
                    }
                }
                else {
                    Write-Host "  ✅ Seção '$SecKey' ($SecType) preenchida corretamente." -ForegroundColor Green
                }
            }
            else {
                # Se a seção está ausente
                if ($SecType -eq "OBRIGATÓRIO") {
                    Write-Host "  ❌ [ERRO] Seção OBRIGATÓRIA '$SecKey' está ausente (foi removida do arquivo)." -ForegroundColor Red
                    $ErrorCount++
                }
            }
        }
    }
    else {
        # Arquivo customizado sem template declarada (apenas validação de links markdown)
        Write-Host "`nAnalisando Documento Customizado: $($File.FullName)" -ForegroundColor DarkGray
    }
    
    # 5. Validação Genérica de Links Markdown Relativos
    $Lines = $FileText -split "`r?\n"
    for ($i = 0; $i -lt $Lines.Count; $i++) {
        $Line = $Lines[$i]
        $LineNum = $i + 1
        
        # Procura por links no formato [texto](caminho) excluindo URLs absolutas (http/https/mailto)
        $Links = [regex]::Matches($Line, "\[([^\]]+)\]\(([^)]+)\)")
        foreach ($Link in $Links) {
            $LinkText = $Link.Groups[1].Value
            $LinkPath = $Link.Groups[2].Value

            # Ignorar URLs HTTP/HTTPS, âncoras locais (#) e links de e-mail
            if ($LinkPath -match "^(https?://|mailto:|#)") {
                continue
            }

            # Remover possíveis âncoras do link (ex: ./tecnica.md#secao)
            $CleanLinkPath = $LinkPath -replace "#.*$", ""
            if ([string]::IsNullOrWhiteSpace($CleanLinkPath)) {
                continue
            }

            # Resolver caminho relativo com base no diretório do arquivo atual
            $ResolvedPath = [System.IO.Path]::Combine($FileDir, $CleanLinkPath)
            
            if (-not (Test-Path $ResolvedPath)) {
                Write-Host "  ❌ [LINK QUEBRADO] Linha $($LineNum): O link '$LinkText' aponta para '$LinkPath' (Arquivo não encontrado: $ResolvedPath)" -ForegroundColor Red
                $ErrorCount++
            }
        }
    }
}

Write-Host "`n==========================================" -ForegroundColor Cyan
if ($ErrorCount -eq 0) {
    Write-Host "Auditoria concluída com SUCESSO! Nenhuma pendência encontrada." -ForegroundColor Green
    if ($WarningCount -gt 0) {
        Write-Host "Houve $WarningCount aviso(s) secundário(s)." -ForegroundColor Yellow
    }
    exit 0
}
else {
    Write-Host "Auditoria concluída com FALHA. Encontrados $ErrorCount erro(s) e $WarningCount aviso(s)." -ForegroundColor Red
    exit 1
}
