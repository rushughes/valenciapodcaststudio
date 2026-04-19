# User decisions log

Every choice the user has explicitly made, with dates, so future Claude sessions don't re-ask. Append new decisions here rather than rewriting.

## 2026-04-19 — Initial planning session

User: Rus Hughes (GitHub: `rushughes`). Working directory on previous Mac: `/Users/rus/Documents/GitHub/valenciapodcaststudio/`.

### Domain & goal

- Owns `valenciapodcaststudio.com`.
- Goal: rank-and-rent — make as much money as possible by leasing the platform to the highest-paying podcast studio.
- Chose Hugo over his usual WordPress.
- Chose Blowfish theme (`github.com/nunocoracao/blowfish`) based on an external recommendation.

### Monetization model

**Chosen:** Single exclusive sponsor ("rent the platform"). Rejected: tiered paid listings, lead-gen/affiliate model, hybrid rankings+lead-capture.

Rationale (from plan): simplest sales motion, highest margin, best fit for the small Valencia market. Trade-off accepted: slower to start earning.

### Languages

**Chosen:** Spanish primary + English secondary. Rejected: Spanish-only, English-only, trilingual including Valencian.

Rationale: covers local intent (`estudio de podcast Valencia`) plus expat/tourist intent (`podcast studio Valencia`) without the translator overhead of adding Valencian.

### Hosting

**Chosen:** User's existing VPS, deploy via SSH/rsync. Rejected: static hosts (Cloudflare Pages / Netlify), new VPS recommendation, shared hosting.

Implication: need VPS connection details before the first production deploy. See `HANDOFF.md` § "Open questions".

### Deploy pipeline

**Chosen:** Local Docker build → rsync from Mac to VPS. Rejected: GitHub Actions deploy-on-push, hybrid (local for preview + Actions for prod).

Rationale: user wants a manual gate on every production push; avoids CI secrets; matches his stated preference.

Note: GitHub Actions is still used for build-check on PRs (plan item 11) — that's a lint/smoke gate, not a deploy.

### Studio research

**Chosen:** Research from scratch. Rejected: user-supplied partial list, user-supplied complete list.

Implication: Phase 2 of the plan includes a research sub-phase to compile `data/studios.yaml` from Google Maps, Instagram (`#estudiopodcastvalencia`), Valencia business directories. Target 12–15 studios.

### Content writing

**Chosen:** AI-assisted drafts, human-reviewed. Rejected: hire native copywriter, write-it-myself.

Implication: `docs/prompts/review-template.md` needs to exist before content creation starts.

### SEO depth

**Chosen:** Full local SEO stack. Rejected: standard/minimal SEO only.

Scope: JSON-LD `LocalBusiness` + `Review` + `ItemList` + `BreadcrumbList` + `FAQPage` schemas, hreflang for ES/EN, XML sitemap, robots.txt, OpenGraph, 5–6 programmatic neighborhood pages, internal linking structure, Google Business Profile strategy doc, backlink outreach plan.
