# Manual BHO2MGB em português

O arquivo `index.md` é a fonte oficial desta documentação. As figuras e os arquivos de renderização do PDF ficam na pasta [`docs/`](../), e o [PDF pronto](manual-bho2mgb.pdf) é gerado a partir desses arquivos versionados.

## Gerar o PDF

Requisitos: Pandoc, XeLaTeX e a fonte TeX Gyre Termes.

Na raiz do repositório, execute:

```sh
docs/pt/build.sh
```

O comando atualiza `docs/pt/manual-bho2mgb.pdf`.
