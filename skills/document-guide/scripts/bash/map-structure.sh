#!/usr/bin/env bash
# ============================================================
# map-structure.sh — Gera árvore de diretórios em Markdown
#
# Uso:
#   bash scripts/bash/map-structure.sh [OPÇÕES] [CAMINHO]
#
# Argumentos posicionais:
#   CAMINHO   Diretório raiz a mapear. Use '.' para o projeto
#             inteiro, './pasta' para uma subpasta.
#             Padrão: . (diretório atual)
#
# Opções:
#   -o, --output   FILE     Salva o resultado no arquivo informado
#   -m, --max-depth N       Profundidade máxima (0 = ilimitada, padrão: 0)
#   -a, --append            Anexa ao arquivo de saída existente
#   -A, --include-all       Não ignora node_modules, .git, etc.
#   -h, --help              Exibe esta ajuda
#
# Exemplos:
#   bash scripts/bash/map-structure.sh
#   bash scripts/bash/map-structure.sh ./docs
#   bash scripts/bash/map-structure.sh . --output ./docs/estrutura.md
#   bash scripts/bash/map-structure.sh . --max-depth 3
#   bash scripts/bash/map-structure.sh . --include-all
# ============================================================
set -euo pipefail
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# ── Valores padrão ────────────────────────────────────────────────────────────
TARGET_PATH="."
OUTPUT_FILE=""
MAX_DEPTH=0
INCLUDE_ALL=false
APPEND=false

# ── Cores ─────────────────────────────────────────────────────────────────────
CYAN='\033[0;36m'
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
GRAY='\033[0;37m'
NC='\033[0m'

# ── Pastas ignoradas por padrão ───────────────────────────────────────────────
DEFAULT_IGNORE=(
  node_modules .git .svn .hg
  dist build out bin obj
  .next .nuxt .venv venv __pycache__
  .turbo .cache coverage .nyc_output
  vendor Pods .DS_Store
)

# ── Parser de argumentos ──────────────────────────────────────────────────────
show_help() {
  sed -n '2,/^# ===/p' "$0" | sed 's/^# \{0,1\}//'
  exit 0
}

POSITIONAL=()
while [[ $# -gt 0 ]]; do
  case "$1" in
  -o | --output)
    OUTPUT_FILE="$2"
    shift 2
    ;;
  -m | --max-depth)
    MAX_DEPTH="$2"
    shift 2
    ;;
  -a | --append)
    APPEND=true
    shift
    ;;
  -A | --include-all)
    INCLUDE_ALL=true
    shift
    ;;
  -h | --help) show_help ;;
  -*)
    echo -e "${RED}[ERRO] Opção desconhecida: '$1'. Use --help.${NC}"
    exit 1
    ;;
  *)
    POSITIONAL+=("$1")
    shift
    ;;
  esac
done

[[ ${#POSITIONAL[@]} -gt 0 ]] && TARGET_PATH="${POSITIONAL[0]}"

# ── Validar caminho ───────────────────────────────────────────────────────────
if [[ ! -d "$TARGET_PATH" ]]; then
  echo -e "${RED}[ERRO] Caminho não encontrado: '$TARGET_PATH'${NC}"
  exit 1
fi

ABS_PATH="$(realpath "$TARGET_PATH")"
ROOT_NAME="$(basename "$ABS_PATH")"
[[ -z "$ROOT_NAME" ]] && ROOT_NAME="$ABS_PATH"

DEPTH_LABEL="ilimitada"
[[ $MAX_DEPTH -gt 0 ]] && DEPTH_LABEL="${MAX_DEPTH} nível(is)"

FILTER_LABEL="$(
  IFS=', '
  echo "${DEFAULT_IGNORE[*]}"
)"
$INCLUDE_ALL && FILTER_LABEL="nenhum (modo --include-all)"

OUT_LABEL="${OUTPUT_FILE:-(somente console)}"

echo ""
echo -e "${CYAN}==========================================${NC}"
echo -e "${CYAN} Mapeando Estrutura do Projeto            ${NC}"
echo -e "${CYAN}==========================================${NC}"
echo -e "${GRAY} Raiz      : $ABS_PATH${NC}"
echo -e "${GRAY} Arquivo   : $OUT_LABEL${NC}"
echo -e "${GRAY} Profund.  : $DEPTH_LABEL${NC}"
echo -e "${GRAY} Ignorando : $FILTER_LABEL${NC}"
echo -e "${CYAN}==========================================${NC}"
echo ""

# ── Verificar se o nome está na lista de ignorados ────────────────────────────
should_ignore() {
  local name="$1"
  $INCLUDE_ALL && return 1
  for ignored in "${DEFAULT_IGNORE[@]}"; do
    [[ "$name" == "$ignored" ]] && return 0
  done
  return 1
}

# ── Função recursiva para gerar a árvore ──────────────────────────────────────
TREE_LINES=()

walk_tree() {
  local dir="$1"
  local prefix="$2"
  local depth="$3"

  [[ $MAX_DEPTH -gt 0 && $depth -gt $MAX_DEPTH ]] && return

  # Listar: pastas primeiro, depois arquivos, ordenado por nome
  local entries=()
  while IFS= read -r -d '' entry; do
    entries+=("$entry")
  done < <(
    {
      find "$dir" -maxdepth 1 -mindepth 1 -type d -print0 | sort -z
      find "$dir" -maxdepth 1 -mindepth 1 ! -type d -print0 | sort -z
    }
  )

  # Filtrar ignorados
  local filtered=()
  for entry in "${entries[@]}"; do
    local name
    name="$(basename "$entry")"
    should_ignore "$name" && continue
    filtered+=("$entry")
  done

  local count="${#filtered[@]}"
  local idx=0

  for entry in "${filtered[@]}"; do
    local name
    name="$(basename "$entry")"
    ((idx++)) || true
    local is_last=false
    [[ $idx -eq $count ]] && is_last=true

    local connector="├── "
    local next_prefix="${prefix}│   "
    if $is_last; then
      connector="└── "
      next_prefix="${prefix}    "
    fi

    if [[ -d "$entry" ]]; then
      TREE_LINES+=("${prefix}${connector}${name}/")
      walk_tree "$entry" "$next_prefix" $((depth + 1))
    else
      TREE_LINES+=("${prefix}${connector}${name}")
    fi
  done
}

# ── Montar a árvore ───────────────────────────────────────────────────────────
TREE_LINES=("${ROOT_NAME}/")
walk_tree "$ABS_PATH" "" 1

# ── Montar bloco Markdown ─────────────────────────────────────────────────────
FENCE='```'
RESULT="${FENCE}"$'\n'
for line in "${TREE_LINES[@]}"; do
  RESULT+="${line}"$'\n'
done
RESULT+="${FENCE}"$'\n'

# ── Exibir no console ─────────────────────────────────────────────────────────
echo "$RESULT"

# ── Salvar em arquivo (se solicitado) ─────────────────────────────────────────
if [[ -n "$OUTPUT_FILE" ]]; then
  output_dir="$(dirname "$OUTPUT_FILE")"
  if [[ ! -d "$output_dir" ]]; then
    mkdir -p "$output_dir"
    echo -e "${YELLOW}📁 Diretório criado: $output_dir${NC}"
  fi

  if $APPEND && [[ -f "$OUTPUT_FILE" ]]; then
    printf '\n%s' "$RESULT" >>"$OUTPUT_FILE"
    echo -e "${GREEN}✅ Estrutura anexada em: $OUTPUT_FILE${NC}"
  else
    printf '%s' "$RESULT" >"$OUTPUT_FILE"
    echo -e "${GREEN}✅ Estrutura salva em: $OUTPUT_FILE${NC}"
  fi
fi

echo ""
echo -e "${CYAN}==========================================${NC}"
echo -e "${GREEN} Mapeamento concluído com sucesso         ${NC}"
echo -e "${CYAN}==========================================${NC}"
echo ""

exit 0
