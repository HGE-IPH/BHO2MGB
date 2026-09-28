#!/usr/bin/env bash
set -euo pipefail

DOC_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
cd "$DOC_DIR"

command -v pandoc >/dev/null || { echo "Pandoc is required to build the manual." >&2; exit 1; }
command -v xelatex >/dev/null || { echo "XeLaTeX is required to build the manual." >&2; exit 1; }

pandoc index.md \
  --from=markdown-implicit_figures \
  --lua-filter=sections.lua \
  --lua-filter=figures.lua \
  --standalone \
  --number-sections \
  --toc \
  --toc-depth=4 \
  --pdf-engine=xelatex \
  --template=template.tex \
  --resource-path=. \
  --output=manual-bho2mgb.pdf
