# Claude Code project context — valenciapodcaststudio.com

**This file is auto-loaded by Claude Code. Read it first. Then read `HANDOFF.md` for session continuity.**

## What this project is

A bilingual (Spanish primary / English secondary) Hugo + Blowfish directory that ranks and reviews podcast studios in Valencia, Spain. The domain `valenciapodcaststudio.com` is owned by the user (`rushughes` on GitHub). Goal: rank #1 on Google for local commercial keywords and lease a single exclusive "Patrocinador #1" sponsorship slot. It is a rank-and-rent asset, not a SaaS or service business.

## Business model (non-negotiable — user chose this 2026-04-19)

- **Single exclusive sponsor** model. Not tiered listings, not marketplace, not affiliate.
- Rankings stay **editorial** (disclosed when promoted) to protect Google trust.
- Sponsor rotation is a one-file operation: edit `data/sponsor.yaml` and redeploy.
- Target sponsor price €150–300/mo, 3- or 6-month blocks, raised once leads flow.
- **Do not** start sponsor sales outreach until the site ranks top-5 for ≥2 target keywords (~60–90 days after launch).

## Target keywords (optimize every technical decision for these)

- `estudio de podcast Valencia`
- `alquiler estudio podcast Valencia`
- `podcast studio Valencia` (English)
- Neighborhood long-tails: `estudio de podcast Ruzafa` / `El Carmen` / `Eixample` / `Benimaclet` / `El Cabanyal` / `Campanar`

## Tech stack (decided, do not relitigate)

- **Hugo Extended ≥ 0.141.0** (required by Blowfish). User's Mac has 0.157.0 via Homebrew.
- **Blowfish theme** installed as a **Hugo Module** (not git submodule — theme author's recommendation, cleaner overrides).
- **Docker** for reproducible local builds. User wants consistency across machines.
- **rsync over SSH** from local Mac to user's existing VPS for production deploys. Deliberately **not** GitHub Actions deploy — user wants a manual gate on every prod push.
- **GitHub Actions** only runs a build-check on PRs (no deploy).
- Source in a GitHub repo under `rushughes`.

## Key conventions

- `data/studios.yaml` is the **single source of truth** for NAP (name/address/phone). Never inline NAP in content files — partials read from this file for SEO consistency.
- `data/sponsor.yaml` is the **only** file that changes when rotating sponsors.
- Custom layouts / partials / shortcodes live in `/layouts/` and override Blowfish — **do not fork the theme**.
- Spanish is the default language (no URL prefix). English lives under `/en/` and mirrors **only** the top-3 commercial pages, not everything.
- Editorial rating methodology must be a public, linkable page (`/guias/metodologia/`) — required for E-E-A-T.

## What to read next

1. `HANDOFF.md` — current session state, what's done, what's next, open questions.
2. `docs/plan.md` — the full approved implementation plan.
3. `docs/decisions.md` — record of user choices (to avoid re-asking).

## Things to NOT do

- Don't install Blowfish as a git submodule.
- Don't deploy from GitHub Actions.
- Don't suggest alternative themes — Blowfish is chosen.
- Don't suggest alternative monetization (tiered listings, affiliate, ads) — user explicitly chose single-sponsor.
- Don't suggest WordPress — user explicitly moved away from it.
- Don't create a Google Business Profile for the directory (violates Google policy for directory sites without a physical location).
- Don't commit unless the user asks.
