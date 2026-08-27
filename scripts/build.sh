#!/usr/bin/env sh
set -eu

mkdocs build --strict
touch site/.nojekyll

# mkdocs-static-i18n requires the canonical locale spelling (pt-BR). Publish a
# lowercase copy on case-sensitive CI filesystems so /pt-br/ stays stable.
# macOS' default case-insensitive filesystem already resolves both spellings.
if [ "$(uname -s)" != "Darwin" ]; then
  rm -rf site/pt-br
  cp -R site/pt-BR site/pt-br
fi
