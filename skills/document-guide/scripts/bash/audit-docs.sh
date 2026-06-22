#!/usr/bin/env bash
# ============================================================
# audit-docs.sh — Audita integridade da documentação Markdown
#
# Uso:
#   bash scripts/bash/audit-docs.sh [CAMINHO]
#
# Argumentos:
#   CAMINHO   Diretório com os arquivos .md a auditar.
#             Padrão: . (diretório atual)
#
# Exemplos:
#   bash scripts/bash/audit-docs.sh
#   bash scripts/bash/audit-docs.sh ./docs
# ============================================================
set -euo pipefail
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

SEARCH_PATH="${1:-.}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TEMPLATES_DIR="$(realpath "$SCRIPT_DIR/../../templates")"

ERROR_COUNT=0
WARNING_COUNT=0

# ── Cores ─────────────────────────────────────────────────────────────────────
CYAN='\033[0;36m'
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
GRAY='\033[0;37m'
BLUE='\033[0;34m'
DARK_GRAY='\033[1;30m'
NC='\033[0m' # No Color

echo ""
echo -e "${CYAN}==========================================${NC}"
echo -e "${CYAN} Iniciando Auditoria de Documentação      ${NC}"
echo -e "${CYAN}==========================================${NC}"
echo -e "${GRAY} Diretório: $SEARCH_PATH${NC}"
echo -e "${CYAN}==========================================${NC}"

# ── Validações iniciais ────────────────────────────────────────────────────────
if [[ ! -d "$TEMPLATES_DIR" ]]; then
  echo -e "${RED}[ERRO] Pasta de templates não encontrada: '$TEMPLATES_DIR'${NC}"
  exit 1
fi

if [[ ! -d "$SEARCH_PATH" ]]; then
  echo -e "${RED}[ERRO] Caminho '$SEARCH_PATH' não encontrado.${NC}"
  exit 1
fi

ABS_SEARCH_PATH="$(realpath "$SEARCH_PATH")"

# ── Pastas a ignorar na busca ──────────────────────────────────────────────────
PRUNE_PATTERN=( -path "*/node_modules/*" -o -path "*/.git/*" -o -path "*/.github/*"
                -o -path "*/.agents/*"    -o -path "*/.gemini/*" -o -path "*/brain/*"
                -o -path "*/templates/*" -o -path "*/references/*" -o -path "*/scripts/*" )

# ── Carregar biblioteca de templates ──────────────────────────────────────────
# Estrutura: TMPL_SECTIONS["funcional:SECAO"]="OBRIGATORIO|OPCIONAL:conteudo_padrao"
declare -A TMPL_SECTIONS

while IFS= read -r -d '' tmpl_file; do
  tmpl_text="$(cat "$tmpl_file")"

  # Extrair nome do template: <!-- TEMPLATE: nome -->
  tmpl_name=""
  if [[ "$tmpl_text" =~ \<\!--[[:space:]]*TEMPLATE:[[:space:]]*([a-zA-Z0-9_]+)[[:space:]]*--\> ]]; then
    tmpl_name="${BASH_REMATCH[1]}"
  fi
  [[ -z "$tmpl_name" ]] && continue

  # Extrair seções: <!-- INICIO:SECAO (TIPO) --> ... <!-- FIM:SECAO -->
  while IFS= read -r sec_line; do
    if [[ "$sec_line" =~ \<\!--[[:space:]]*INICIO:([A-Z_]+)[[:space:]]*(\(([A-Z]+)\))?[[:space:]]*--\> ]]; then
      sec_id="${BASH_REMATCH[1]}"
      sec_type="${BASH_REMATCH[3]:-OPCIONAL}"
      # Capturar conteúdo entre INICIO e FIM
      sec_content="$(echo "$tmpl_text" \
        | awk "/<!--[[:space:]]*INICIO:${sec_id}[^>]*-->/{found=1; next} /<!--[[:space:]]*FIM:${sec_id}[[:space:]]*-->/{found=0} found{print}" \
        | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')"
      TMPL_SECTIONS["${tmpl_name}:${sec_id}"]="${sec_type}:${sec_content}"
    fi
  done <<< "$tmpl_text"
done < <(find "$TEMPLATES_DIR" -name "*-template.md" -print0)

# ── Localizar arquivos .md do projeto ─────────────────────────────────────────
mapfile -d '' MD_FILES < <(find "$ABS_SEARCH_PATH" \
  \( "${PRUNE_PATTERN[@]}" \) -prune -o \
  -name "*.md" -print0)

if [[ ${#MD_FILES[@]} -eq 0 ]]; then
  echo -e "${YELLOW}Nenhum arquivo .md encontrado para auditoria.${NC}"
  exit 0
fi

# ── Validar cada arquivo ───────────────────────────────────────────────────────
for md_file in "${MD_FILES[@]}"; do
  [[ -z "$md_file" ]] && continue
  file_text="$(cat "$md_file")"
  file_dir="$(dirname "$md_file")"

  # Verificar declaração de template
  used_tmpl=""
  if [[ "$file_text" =~ \<\!--[[:space:]]*TEMPLATE:[[:space:]]*([a-zA-Z0-9_]+)[[:space:]]*--\> ]]; then
    used_tmpl="${BASH_REMATCH[1]}"
  fi

  if [[ -n "$used_tmpl" ]]; then
    # Verificar se template existe na biblioteca
    known=false
    for key in "${!TMPL_SECTIONS[@]}"; do
      [[ "$key" == "${used_tmpl}:"* ]] && known=true && break
    done

    if ! $known; then
      echo -e "${YELLOW}⚠ [AVISO] '$( basename "$md_file")' declara template '$used_tmpl' não registrado.${NC}"
      (( WARNING_COUNT++ )) || true
    else
      echo ""
      echo -e "${BLUE}Analisando: $md_file${NC}"
      echo -e "${GRAY}Template : $used_tmpl${NC}"

      # Iterar seções do template
      for key in "${!TMPL_SECTIONS[@]}"; do
        [[ "$key" != "${used_tmpl}:"* ]] && continue
        sec_id="${key#*:}"
        sec_meta="${TMPL_SECTIONS[$key]}"
        sec_type="${sec_meta%%:*}"
        sec_default="${sec_meta#*:}"

        # Extrair conteúdo do arquivo para essa seção
        user_content="$(echo "$file_text" \
          | awk "/<!--[[:space:]]*INICIO:${sec_id}[^>]*-->/{found=1; next} /<!--[[:space:]]*FIM:${sec_id}[[:space:]]*-->/{found=0} found{print}" \
          | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')"

        sec_present=false
        if echo "$file_text" | grep -q "<!-- INICIO:${sec_id}"; then
          sec_present=true
        fi

        if $sec_present; then
          if [[ -z "$user_content" || "$user_content" == "$sec_default" ]]; then
            if [[ "$sec_type" == "OBRIGATÓRIO" || "$sec_type" == "OBRIGATORIO" ]]; then
              echo -e "  ${RED}❌ [ERRO] Seção OBRIGATÓRIA '$sec_id' não foi preenchida.${NC}"
            else
              echo -e "  ${RED}❌ [ERRO] Seção OPCIONAL '$sec_id' não foi preenchida nem removida.${NC}"
              echo -e "  ${GRAY}   (Dica: remova todo o bloco INICIO/FIM se não for usar.)${NC}"
            fi
            (( ERROR_COUNT++ )) || true
          else
            echo -e "  ${GREEN}✅ Seção '$sec_id' ($sec_type) preenchida corretamente.${NC}"
          fi
        else
          if [[ "$sec_type" == "OBRIGATÓRIO" || "$sec_type" == "OBRIGATORIO" ]]; then
            echo -e "  ${RED}❌ [ERRO] Seção OBRIGATÓRIA '$sec_id' está ausente.${NC}"
            (( ERROR_COUNT++ )) || true
          fi
        fi
      done
    fi
  else
    echo ""
    echo -e "${DARK_GRAY}Analisando (sem template): $md_file${NC}"
  fi

  # ── Validar links relativos ────────────────────────────────────────────────
  line_num=0
  while IFS= read -r line; do
    (( line_num++ )) || true
    # Capturar links [texto](caminho) excluindo http, https, mailto, âncoras
    while [[ "$line" =~ \[([^]]+)\]\(([^)]+)\) ]]; do
      link_text="${BASH_REMATCH[1]}"
      link_path="${BASH_REMATCH[2]}"
      # Remover a ocorrência já processada para evitar loop infinito
      line="${line/"[${link_text}](${link_path})"/}"

      # Ignorar URLs absolutas e âncoras
      [[ "$link_path" =~ ^(https?://|mailto:|#) ]] && continue

      # Remover âncora interna do caminho
      clean_path="${link_path%%#*}"
      [[ -z "$clean_path" ]] && continue

      resolved="$(realpath "$file_dir/$clean_path" 2>/dev/null || true)"
      if [[ ! -e "$resolved" ]]; then
        echo -e "  ${RED}❌ [LINK QUEBRADO] Linha ${line_num}: '$link_text' → '$link_path' (não encontrado)${NC}"
        (( ERROR_COUNT++ )) || true
      fi
    done
  done < "$md_file"
done

# ── Resultado final ────────────────────────────────────────────────────────────
echo ""
echo -e "${CYAN}==========================================${NC}"
if [[ $ERROR_COUNT -eq 0 ]]; then
  echo -e "${GREEN}Auditoria concluída com SUCESSO. Nenhuma pendência encontrada.${NC}"
  [[ $WARNING_COUNT -gt 0 ]] && echo -e "${YELLOW}Houve $WARNING_COUNT aviso(s).${NC}"
  echo -e "${CYAN}==========================================${NC}"
  exit 0
else
  echo -e "${RED}Auditoria concluída com FALHA. $ERROR_COUNT erro(s), $WARNING_COUNT aviso(s).${NC}"
  echo -e "${CYAN}==========================================${NC}"
  exit 1
fi
