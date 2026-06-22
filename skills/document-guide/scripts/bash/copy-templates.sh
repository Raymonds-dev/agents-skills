#!/usr/bin/env bash
# ============================================================
# copy-templates.sh — Copia templates de documentação para docs/
#
# Uso:
#   bash scripts/bash/copy-templates.sh [OPÇÕES]
#
# Opções:
#   -p, --project-path PATH     Raiz do projeto destino (padrão: .)
#   -d, --docs-dir    DIR       Subdiretório de docs (padrão: docs)
#   -t, --templates   LISTA     Templates separados por vírgula:
#                               funcional,operacional,tecnica,arquitetural,adr
#                               (padrão: todos)
#   -f, --force                 Sobrescreve sem confirmação
#   -h, --help                  Exibe esta ajuda
#
# Exemplos:
#   bash scripts/bash/copy-templates.sh
#   bash scripts/bash/copy-templates.sh --templates funcional,adr
#   bash scripts/bash/copy-templates.sh --project-path ../meu-projeto --force
# ============================================================
set -euo pipefail
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TEMPLATES_DIR="$(realpath "$SCRIPT_DIR/../../templates")"

# ── Valores padrão ────────────────────────────────────────────────────────────
PROJECT_PATH="."
DOCS_DIR="docs"
SELECTED_TEMPLATES="funcional operacional tecnica arquitetural adr"
FORCE=false

# ── Cores ─────────────────────────────────────────────────────────────────────
CYAN='\033[0;36m'
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
GRAY='\033[0;37m'
DARK_GRAY='\033[1;30m'
NC='\033[0m'

# ── Parser de argumentos ───────────────────────────────────────────────────────
show_help() {
  sed -n '2,/^# ===/p' "$0" | sed 's/^# \{0,1\}//'
  exit 0
}

while [[ $# -gt 0 ]]; do
  case "$1" in
  -p | --project-path)
    PROJECT_PATH="$2"
    shift 2
    ;;
  -d | --docs-dir)
    DOCS_DIR="$2"
    shift 2
    ;;
  -t | --templates)
    SELECTED_TEMPLATES="${2//,/ }"
    shift 2
    ;;
  -f | --force)
    FORCE=true
    shift
    ;;
  -h | --help) show_help ;;
  *)
    echo -e "${RED}[ERRO] Argumento desconhecido: '$1'. Use --help para ver as opções.${NC}"
    exit 1
    ;;
  esac
done

# ── Mapeamento: chave → arquivo de template e nome de saída ───────────────────
declare -A TMPL_FILE=(
  [funcional]="funcional-template.md"
  [operacional]="operacional-template.md"
  [tecnica]="tecnica-template.md"
  [arquitetural]="arquitetural-template.md"
  [adr]="adr-template.md"
)

declare -A TMPL_OUT=(
  [funcional]="funcional.md"
  [operacional]="operacional.md"
  [tecnica]="tecnica.md"
  [arquitetural]="arquitetural.md"
  [adr]="adr.md"
)

VALID_KEYS="${!TMPL_FILE[*]}"

# ── Caminhos resolvidos ───────────────────────────────────────────────────────
PROJECT_ABS="$(realpath "$PROJECT_PATH")"
DOCS_PATH="$PROJECT_ABS/$DOCS_DIR"

COPIED=0
SKIPPED=0
ERRORS=0

echo ""
echo -e "${CYAN}==========================================${NC}"
echo -e "${CYAN} Copiando Templates de Documentação       ${NC}"
echo -e "${CYAN}==========================================${NC}"
echo -e "${GRAY} Projeto  : $PROJECT_ABS${NC}"
echo -e "${GRAY} Destino  : $DOCS_PATH${NC}"
echo -e "${GRAY} Templates: $(echo "$SELECTED_TEMPLATES" | tr ' ' ',')${NC}"
echo -e "${CYAN}==========================================${NC}"
echo ""

# ── Validar pasta de templates ────────────────────────────────────────────────
if [[ ! -d "$TEMPLATES_DIR" ]]; then
  echo -e "${RED}❌ [ERRO] Pasta de templates não encontrada: '$TEMPLATES_DIR'${NC}"
  exit 1
fi

# ── Criar docs/ se não existir ────────────────────────────────────────────────
if [[ ! -d "$DOCS_PATH" ]]; then
  mkdir -p "$DOCS_PATH"
  echo -e "${YELLOW}📁 Diretório '$DOCS_DIR/' criado em: $DOCS_PATH${NC}"
fi

# ── Copiar templates selecionados ─────────────────────────────────────────────
for key in $SELECTED_TEMPLATES; do
  key_lower="${key,,}" # lowercase

  if [[ -z "${TMPL_FILE[$key_lower]+_}" ]]; then
    echo -e "  ${YELLOW}⚠  [AVISO] Template desconhecido: '$key'. Aceitos: $VALID_KEYS${NC}"
    ((SKIPPED++)) || true
    continue
  fi

  src="$TEMPLATES_DIR/${TMPL_FILE[$key_lower]}"
  dst="$DOCS_PATH/${TMPL_OUT[$key_lower]}"

  if [[ ! -f "$src" ]]; then
    echo -e "  ${RED}❌ [ERRO] Arquivo não encontrado: '$src'${NC}"
    ((ERRORS++)) || true
    continue
  fi

  # Verificar sobrescrita
  if [[ -f "$dst" ]] && ! $FORCE; then
    read -rp "  ⚠  '${TMPL_OUT[$key_lower]}' já existe em $DOCS_DIR/. Sobrescrever? (s/N) " answer
    if [[ ! "$answer" =~ ^[sS]$ ]]; then
      echo -e "  ${DARK_GRAY}⏭  Pulando: ${TMPL_OUT[$key_lower]}${NC}"
      ((SKIPPED++)) || true
      continue
    fi
  fi

  cp "$src" "$dst"
  echo -e "  ${GREEN}✅ Copiado: ${TMPL_OUT[$key_lower]}${NC}"
  ((COPIED++)) || true
done

# ── Resumo final ──────────────────────────────────────────────────────────────
echo ""
echo -e "${CYAN}==========================================${NC}"
if [[ $ERRORS -eq 0 ]]; then
  echo -e "${GREEN}Concluído. $COPIED template(s) copiado(s). $SKIPPED ignorado(s).${NC}"
else
  echo -e "${YELLOW}Concluído com $ERRORS erro(s). $COPIED copiado(s), $SKIPPED ignorado(s).${NC}"
fi
echo -e "${CYAN}==========================================${NC}"
echo ""

[[ $ERRORS -gt 0 ]] && exit 1 || exit 0
