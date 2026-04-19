# valenciapodcaststudio.com

Bilingual (ES/EN) Hugo + Blowfish directory ranking and reviewing podcast studios in Valencia. Built for rank-and-rent: one exclusive sponsor slot, leased monthly.

## Stack

- Hugo Extended ≥ 0.141.0
- Blowfish theme (Hugo Module)
- Docker for local builds
- rsync over SSH for production deploy

## Quick start

```bash
make dev            # run hugo server in Docker at http://localhost:1313
make build          # build static site into ./public
make new-studio SLUG=mi-estudio
make lint           # strict build + htmltest
make deploy         # build + rsync to VPS (requires .env.deploy)
```

See `docs/` for server setup, editorial calendar, GBP strategy, backlink plan, and AI prompt templates.

## Repo map

- `config/_default/` — Hugo configuration (ES default, EN secondary)
- `content/` — Spanish content (default)
- `content.en/` — English content (commercial pages only)
- `data/studios.yaml` — single source of truth for NAP
- `data/sponsor.yaml` — current sponsor rotation config
- `layouts/` — Blowfish overrides (schema partials, studio templates)
- `deploy/` — nginx reference config, rsync exclude list
- `docs/` — operational docs (not published)
