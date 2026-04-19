# Valencia Podcast Studios — Hugo Site + Rank-and-Rent Strategy

## Context

You own `valenciapodcaststudio.com` and want to turn it into a rank-and-rent asset: a bilingual (ES/EN) directory that reviews and ranks podcast studios in Valencia, dominates local SEO, and is then leased exclusively to the highest-paying studio. Stack is Hugo + Blowfish theme, built locally on Mac via Docker, source in GitHub, deployed to your VPS via rsync over SSH. Content will be AI-drafted and human-reviewed. Target: a production-ready site + SEO moat + a sellable sponsorship offer.

The key strategic insight: the site's value comes from ranking #1 for a small set of commercial queries (`estudio de podcast Valencia`, `alquiler estudio podcast Valencia`, `podcast studio Valencia`, neighborhood variants). We optimize every technical and content decision for that outcome.

---

## Business Strategy

### Monetization model: exclusive sponsorship ("rank and rent")

- One "Featured / Patrocinador #1" slot, sold monthly. Winner gets: top banner on homepage, "Recomendado" badge, phone/WhatsApp click-to-call, contact form leads forwarded, featured position in every listing page, dedicated deep-dive article linked from every review.
- Rankings remain editorial; sponsorship is clearly disclosed (`#publi` / `Patrocinado`). This protects long-term Google trust — fake-looking pay-to-win rankings get reported and deranked.
- Secondary revenue: reserve 2–3 "verified listing" tiers (€49–99/mo) for non-#1 studios who want a phone link + logo. Optional, added once organic traffic is proven.
- Lead-capture form on every studio page: leads delivered to whoever is the current sponsor. This is the real product — not ad impressions but booked clients.

### Pricing anchor

- Price the sponsorship at ~20–40% of one additional booking/month the site would generate for the sponsor. For Valencia podcast studios (typical session €50–150), a first-month anchor of €150–300/mo is defensible once the site ranks top-3. Raise once leads are flowing.
- Sell in 3- or 6-month blocks to reduce churn and give Google time to stabilize.

### Sales trigger

- Only start outreach to studios once the site is top-5 for at least 2 target keywords. Selling earlier commoditizes the asset. Target: 60–90 days after launch to reach ranking threshold with the full stack below.

### Defensibility (why it stays rented)

- Editorial rankings + reviews + local schema are hard for a studio to replicate on their own corporate site.
- Exclusive slot creates FOMO: if the sponsor drops, a competitor will take it.
- Bilingual ES/EN captures both local and expat demand (Valencia has a large remote/expat podcaster population — high willingness to pay).

---

## Technical Architecture

### Stack

- **Hugo Extended** (≥ 0.141.0, required by Blowfish)
- **Blowfish theme** installed as a Hugo Module (preferred) — easier updates than git submodule
- **Docker** for reproducible local builds (`klakegg/hugo:ext-alpine` or official `hugomods/hugo:exts`)
- **Git + GitHub** (private repo) for source
- **rsync over SSH** from Mac to VPS for deploys, gated by a Makefile target

### Repo layout

```
valenciapodcaststudio/
├── config/
│   └── _default/
│       ├── hugo.toml           # base
│       ├── languages.toml      # es (default) + en
│       ├── menus.es.toml
│       ├── menus.en.toml
│       ├── params.toml         # Blowfish params
│       └── markup.toml
├── content/
│   ├── _index.md               # ES home
│   ├── estudios/               # one file per studio (ES)
│   │   └── <slug>/index.md
│   ├── barrios/                # neighborhood pages (Ruzafa, El Carmen, Benimaclet, Eixample, El Cabanyal)
│   ├── guias/                  # topical SEO content (precios, cómo elegir, equipamiento)
│   └── sobre-nosotros.md
├── content.en/                 # English mirror (only pages that matter for EN intent)
├── layouts/
│   ├── estudios/
│   │   ├── single.html         # custom: rating, map, schema.org/LocalBusiness+Review
│   │   └── list.html           # ranked list w/ ItemList schema
│   ├── partials/
│   │   ├── schema-localbusiness.html
│   │   ├── schema-review.html
│   │   ├── schema-itemlist.html
│   │   ├── rating-stars.html
│   │   ├── sponsor-banner.html
│   │   └── lead-form.html
│   └── shortcodes/
│       ├── studio-card.html
│       ├── price-table.html
│       └── pros-cons.html
├── assets/ static/ data/
├── data/
│   ├── studios.yaml            # single source of truth: name, address, coords, phone, pricing, links
│   └── sponsor.yaml            # current sponsor config (one file to rotate sponsor)
├── i18n/  (es.yaml, en.yaml)
├── Dockerfile.dev              # hugo server for local
├── docker-compose.yml
├── Makefile                    # dev / build / deploy / new-studio
├── .github/workflows/          # CI: build check on PR (no deploy)
└── deploy/
    ├── rsync-exclude.txt
    └── nginx.conf.sample       # reference for VPS
```

### Why Hugo Module (not submodule) for Blowfish

Blowfish docs officially recommend modules. It lets us override any layout cleanly in `layouts/` without forking. Custom partials (schema, rating, sponsor banner) live in our repo; theme updates via `hugo mod get -u`.

---

## Site Structure & Content Model

### Taxonomies (defined in `hugo.toml`)

- `barrios` (neighborhoods) — Ruzafa, El Carmen, Eixample, Benimaclet, El Cabanyal, Campanar
- `servicios` (services) — grabación, edición, vídeo-podcast, alquiler por horas, alquiler por día, streaming
- `equipamiento` (equipment) — Shure SM7B, Rode, etc. (for long-tail)

### URL scheme (ES default, no language prefix; EN under `/en/`)

- `/` — home (ranked list top 10)
- `/estudios/<slug>/` — individual studio page
- `/barrios/ruzafa/` — neighborhood landing (programmatic via taxonomy template)
- `/guias/cuanto-cuesta-alquilar-estudio-podcast-valencia/` — money-keyword guide
- `/guias/como-elegir-estudio-podcast/` — informational
- `/comparativa/` — side-by-side table
- `/en/` + mirrored English tree for top-3 commercial pages only (don't mirror everything — wasted effort)

### Studio page template (the core asset)

Each `content/estudios/<slug>/index.md` has front matter:

```yaml
title: "Nombre Studio"
slug: "nombre-studio"
rating: 4.5
priceFrom: 35
priceUnit: "hora"
address: "Calle ..., 46001 Valencia"
coords: [39.4699, -0.3763]
phone: "+34 ..."
whatsapp: "+34 ..."
website: "https://..."
instagram: "@..."
googleMapsUrl: "..."
barrios: ["Ruzafa"]
servicios: ["grabación", "edición"]
equipamiento: ["Shure SM7B", "Rodecaster"]
pros: ["...", "..."]
cons: ["...", "..."]
verdict: "..."
lastVerified: 2026-04-19
```

The layout `layouts/estudios/single.html` renders: hero + rating stars + pros/cons + price table + embedded map (static image, not iframe, for perf) + lead form + JSON-LD `LocalBusiness` + `Review` + `Product` (for rentable studios) schema.

---

## Local SEO Implementation (the moat)

1. **JSON-LD schema** — custom partials output:
   - `LocalBusiness` on each studio page with full NAP (Name/Address/Phone), `geo`, `openingHoursSpecification`, `priceRange`.
   - `Review` + `aggregateRating` using our editorial rating.
   - `ItemList` on list/ranking pages.
   - `BreadcrumbList` site-wide.
   - `FAQPage` on guides where applicable.
2. **hreflang** — automatic via Hugo multilingual; verify `<link rel="alternate" hreflang="es"/"en"/"x-default">` emitted correctly. Override Blowfish's `<head>` partial if needed.
3. **Sitemap** — Hugo generates `sitemap.xml` per language + index. Confirm Blowfish doesn't suppress it.
4. **robots.txt** — allow all, point to sitemap, disallow `/tags/` noise if it ranks thin.
5. **OpenGraph + Twitter cards** — Blowfish handles; we inject `og:locale` per-language and a studio-specific image.
6. **Programmatic neighborhood pages** — 5–6 `barrios/*` pages, each with intro + list of studios in that barrio + embedded local schema. These rank for `estudio de podcast <barrio>` long-tails.
7. **Internal linking** — every studio page links to its barrio, services, and a "comparativa" page. Every guide links to top-3 studios. Implemented via Hugo's related-content + shortcode.
8. **Core Web Vitals** — Blowfish uses Tailwind + Hugo Pipes; we disable unused features, serve AVIF/WebP, inline critical CSS. Target: 95+ mobile Lighthouse.
9. **NAP consistency** — `data/studios.yaml` is single source of truth; NAP output identically everywhere via partial.
10. **Google Business Profile strategy doc** — separate file `docs/gbp-strategy.md` explaining: we do **not** create a GBP for the directory itself (against Google policy — no physical service location), but we **do** encourage sponsors to optimize their own GBP and we link from our site to theirs with branded anchor. We build citations on Páginas Amarillas / 11870 / Yelp ES pointing to our directory as editorial, not as a business.
11. **Backlink plan doc** — `docs/backlinks.md`: guest posts on Spanish podcasting blogs, HARO/Qwoted pitches, local Valencia blog outreach, listing on Valencia startup directories. Low-volume, high-quality.

---

## Content Workflow (AI-assisted)

1. **Research phase** (week 1): compile `data/studios.yaml` from Google Maps, Instagram searches (`#estudiopodcastvalencia`), and Valencia business directories. Target: 12–15 studios. Manually verify NAP + pricing by calling or checking websites.
2. **Review drafting**: prompt template stored in `docs/prompts/review-template.md`. One review at a time fed studio data → AI produces Spanish draft in Blowfish's expected front-matter format. You or a trusted native speaker edit for tone and factual accuracy before publishing.
3. **Rating methodology**: document in `/guias/metodologia.md` — transparency page covering how scores are derived (equipment, price, location, service breadth, responsiveness, reviews). Critical for E-E-A-T.
4. **Photos**: use studio-provided or Instagram (credited) or AI-generated hero images as placeholder. Replace with originals as studios sponsor.
5. **Freshness**: `lastVerified` field on every studio; quarterly review cycle documented in `docs/editorial-calendar.md`.

---

## Build & Deploy Pipeline

### Local dev (Docker)

- `make dev` → `docker compose up` → Blowfish site at `http://localhost:1313` with live reload.
- `make new-studio SLUG=foo` → scaffold a new studio markdown using an archetype.
- `make build` → Docker-built static site into `public/`.
- `make lint` → `hugo --gc --minify` strict mode; `htmltest` for broken links; `pa11y` for a11y smoke.

### Production deploy

- `make deploy` → `make build` + `rsync -avz --delete --exclude-from=deploy/rsync-exclude.txt public/ user@vps:/var/www/valenciapodcaststudio/`.
- SSH key auth only; server details in `.env.deploy` (git-ignored), loaded by Makefile.
- Nginx on VPS serves from that path; reference `deploy/nginx.conf.sample` (gzip, brotli if available, cache headers, TLS via certbot — setup is one-time manual, documented in `docs/server-setup.md`).
- GitHub Actions on PR runs `hugo --gc --minify` + htmltest only (no deploy) — catches broken builds before merge.

### Rotating the sponsor

- Edit `data/sponsor.yaml` → `make deploy`. No content migration. Single-file change = low-risk operation suitable for monthly rotation.

---

## Phased Rollout

**Phase 1 — Scaffold (days 1–3)**

- Init repo, Hugo module, Blowfish, Docker, Makefile, deploy pipeline end-to-end with one placeholder studio. Ship to VPS. Verify TLS, sitemap, schema validator pass.

**Phase 2 — Content & SEO (days 4–21)**

- Research 12–15 studios into `data/studios.yaml`.
- Draft reviews (AI + edit).
- Build 5 neighborhood pages + 3 pillar guides + methodology page.
- Custom schema partials, hreflang verification, Lighthouse > 95.
- Submit to Google Search Console + Bing Webmaster.

**Phase 3 — Link building & wait (days 21–90)**

- Backlink outreach, directory citations, 1 guest post/week.
- Monitor rankings weekly in GSC.

**Phase 4 — Monetize (day 60+, ranking threshold met)**

- Activate lead form routing.
- Outreach to studios: "You're currently ranked #X on valenciapodcaststudio.com, the #1 Google result for [keyword]. We have a single sponsor slot — here's our pitch."
- Start at €150–300/mo, 3-month minimum.

---

## Critical Files to Create

- `Makefile` — dev/build/deploy/new-studio targets
- `docker-compose.yml`, `Dockerfile.dev`
- `config/_default/hugo.toml` + `languages.toml` + `params.toml`
- `layouts/estudios/single.html` + `list.html`
- `layouts/partials/schema-localbusiness.html`, `schema-review.html`, `schema-itemlist.html`, `sponsor-banner.html`, `lead-form.html`
- `data/studios.yaml`, `data/sponsor.yaml`
- `archetypes/estudios.md`
- `deploy/nginx.conf.sample`, `deploy/rsync-exclude.txt`
- `docs/gbp-strategy.md`, `docs/backlinks.md`, `docs/server-setup.md`, `docs/prompts/review-template.md`, `docs/editorial-calendar.md`
- `.github/workflows/build-check.yml`

## Reused / external

- Blowfish theme (Hugo Module) — no fork, only layout overrides
- Hugo multilingual built-in (hreflang, i18n bundles)
- Hugo's `related` + taxonomy system for internal linking

---

## Verification

After Phase 1 scaffold is shipped, confirm end-to-end:

1. `make dev` — site loads at localhost:1313 in both ES and EN.
2. `make build && ls public/` — `sitemap.xml`, `es/sitemap.xml`, `en/sitemap.xml`, `robots.txt` all present.
3. `make deploy` — site reachable over HTTPS on production domain.
4. **Schema validators**:
   - https://validator.schema.org/ on a studio page → `LocalBusiness` + `Review` parse clean.
   - Google Rich Results Test → eligible for review snippet.
5. **hreflang**: view source of `/` and `/en/` → reciprocal `<link rel="alternate" hreflang=...>` tags.
6. **Lighthouse** (mobile): Performance ≥ 95, SEO = 100, Accessibility ≥ 95.
7. **htmltest**: `make lint` passes with zero broken links.
8. **GSC**: property verified, sitemap submitted, no coverage errors within 48h.
9. **Deploy safety**: `make deploy` twice in a row with no content change → rsync reports 0 files transferred (idempotent).
10. **Sponsor rotation drill**: edit `data/sponsor.yaml` to a dummy sponsor, `make deploy`, verify banner + badge update everywhere, revert.
