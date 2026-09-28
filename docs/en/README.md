# BHO2MGB application manual in English

[`index.md`](index.md) is the source for this manual. Figures and PDF rendering files are shared in the parent [`docs/`](../) folder. [`manual-bho2mgb.pdf`](manual-bho2mgb.pdf) is built from the versioned source.

## Build the PDF

Requires Pandoc, XeLaTeX, and the TeX Gyre Termes font. From the repository root, run:

```sh
docs/en/build.sh
```

This updates `docs/en/manual-bho2mgb.pdf`.
