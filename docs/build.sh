#!/usr/bin/env bash
set -euo pipefail

DOC_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
LANGUAGE="${1:-}"

case "$LANGUAGE" in
  en)
    settings=(
      -V latex-language=english
      -V contents-title=Contents
      -V figure-title=Figure
      -V table-title=Table
      -V 'header-title=APPLICATION MANUAL'
      -V 'cover-first=Application'
      -V 'cover-second=manual'
    )
    ;;
  pt)
    settings=(
      -V latex-language=portuguese
      -V contents-title=Sumário
      -V figure-title=Figura
      -V table-title=Tabela
      -V 'header-title=MANUAL DE APLICAÇÃO'
      -V 'cover-first=Manual de'
      -V 'cover-second=aplicação'
    )
    ;;
  *)
    echo 'Usage: docs/build.sh {en|pt}' >&2
    exit 2
    ;;
esac

command -v pandoc >/dev/null || { echo 'Pandoc is required to build the manual.' >&2; exit 1; }
command -v xelatex >/dev/null || { echo 'XeLaTeX is required to build the manual.' >&2; exit 1; }

cd "$DOC_DIR/$LANGUAGE"
pandoc index.md \
  --from=markdown-implicit_figures \
  --lua-filter=../sections.lua \
  --lua-filter=../figures.lua \
  --lua-filter=../tables.lua \
  --standalone \
  --number-sections \
  --toc \
  --toc-depth=4 \
  --pdf-engine=xelatex \
  --template=../template.tex \
  --resource-path=.:.. \
  "${settings[@]}" \
  --output=manual-bho2mgb.pdf
