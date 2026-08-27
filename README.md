# wireops documentation

The public documentation for [wireops](https://github.com/wireops/wireops),
published at [wireops.dev](https://wireops.dev).

Content lives in `docs/` as Markdown. English is the default language and
Portuguese (Brazil) is published alongside it.

## Local preview

```bash
python3 -m venv .venv
.venv/bin/pip install -r requirements.txt
.venv/bin/mkdocs serve
```

Run `PATH="$PWD/.venv/bin:$PATH" ./scripts/build.sh` before opening a pull
request. GitHub Actions builds and deploys `main` to GitHub Pages.
