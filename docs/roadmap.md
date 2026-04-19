# Roadmap: from live to revenue

Work top-to-bottom. Each task lists deliverable + files to touch. Site is live at https://valenciapodcaststudio.com/ as of 2026-04-19.

---

## Phase 2A — Data hygiene (week 1, ~4h)

Goal: every studio in `data/studios.yaml` has verified NAP + at least one citation source.

1. **Verify NAP for all 6 published studios** — call/email each, confirm address, phone, hours, year founded. Update `data/studios.yaml`. Remove every `# TODO` once filled.
2. **Add coordinates** — Google Maps → right-click → copy lat/lng. Fill `lat:` / `lng:` for each.
3. **Add `lastVerified: 2026-MM-DD`** to each studio front-matter (`content/estudios/*/index.md`) and bump when re-checked.
4. **Take or source one real photo per studio** — store under `assets/studios/{slug}.jpg` (1600×900, <200KB). Update front-matter `featured_image`.
5. **Promote `hive-recording` from draft** once verified, or delete the stub.

Acceptance: `make build` clean, no TODO comments left in `data/studios.yaml`, all studio pages have an image.

---

## Phase 2B — Content depth (weeks 2–4, ~20h)

Follow `docs/editorial-calendar.md`. Use the template in `docs/prompts/review-template.md` for studio-style pages.

1. **6 barrio pages** under `content/barrios/{slug}/_index.md`:
   - `ruzafa`, `el-carmen`, `eixample`, `benimaclet`, `el-cabanyal`, `campanar`
   - Each: 600–900 words, 2–3 studios in that barrio (or "cercano"), local context, target keyword `estudio de podcast {barrio}`.
   - Add `barrio:` taxonomy term in each studio front-matter to backlink them.
2. **3 pillar guides** under `content/guias/`:
   - `cuanto-cuesta-alquilar-un-estudio-de-podcast-en-valencia.md`
   - `como-elegir-estudio-de-podcast.md`
   - `equipamiento-imprescindible-podcast-profesional.md`
   - 1200–1800 words each, link to 3+ studio pages, link to `/guias/metodologia/`.
3. **Comparativa table shortcode** — create `layouts/shortcodes/comparativa-table.html` reading `hugo.Data.studios`, render sortable HTML table (price, capacity, barrio, rating). Re-add `{{< comparativa-table >}}` to `content/comparativa.md`.
4. **EN mirror of top 3 studios** in `content.en/estudios/` (dot-podcast, palette-studio, el-spot-studios) + `content.en/guias/how-to-choose-a-podcast-studio.md`. Keep front-matter `translationKey` matching ES file for hreflang.

Acceptance: sitemap.xml lists ≥25 URLs, every studio links to ≥1 barrio page and ≥1 guide.

---

## Phase 3A — SEO submission (day after Phase 2A, 2h)

1. **Google Search Console** — verify property (DNS TXT). Submit `https://valenciapodcaststudio.com/sitemap.xml`. Set country = Spain.
2. **Bing Webmaster Tools** — import from GSC. Submit sitemap.
3. **Validate schema** — paste each page type into `https://validator.schema.org/` and `https://search.google.com/test/rich-results`. Fix any errors in `layouts/partials/schema-*.html`.
4. **Lighthouse pass** — target Performance ≥ 90, SEO = 100, A11y ≥ 95 on home + one studio page. Fix images (use Hugo `resources.GetMatch | images.Resize`), add `loading="lazy"`.
5. **Confirm `robots.txt`** at `/robots.txt` shows `Allow: /` and sitemap line. (This was a critical earlier fix — don't regress.)

---

## Phase 3B — Backlink outreach (weeks 3–8, ~2h/week)

Follow `docs/backlinks.md`. Target: 10 referring domains in 60 days.

1. Local directories: `paginasamarillas.es`, `valencia.es` business listings, `valenciaplaza.com` events, university media-school pages.
2. Guest posts: pitch one article each to 3 Valencia tech/culture blogs (`valenciaextra.com`, `culturplaza.com`, podcasting newsletters in ES).
3. HARO/Qwoted equivalents in ES (`prensalink.com`).
4. Track in a single sheet: domain, contact, status, link URL, DR.

---

## Phase 3C — Monitoring (set up once, week 2)

1. **GSC weekly export** of queries + impressions (manual, 5 min/week).
2. **Rank tracking** for the 4 target keywords + 6 barrio long-tails — free tier of `serprobot.com` or `nightwatch.io`.
3. **Uptime** — `uptimerobot.com` free monitor on the homepage, alert to user email.
4. **GA4 dashboard** — confirm events flowing for `lead_form` mailto clicks (add `onclick` GA4 event in `layouts/partials/lead-form.html`).

Decision gate: when ≥2 target keywords sit in Google top-5 for 14 consecutive days → start Phase 4.

---

## Phase 4 — Monetize (only after decision gate)

1. **Identify sponsor candidates** — the 6 published studios, ranked by their own SEO weakness (worst-ranking = highest motivation to sponsor).
2. **Outreach email** — 1-pager PDF with: monthly impressions from GA4, top keyword positions from GSC, sample of leads received, price (€150 launch / €300 after first renewal), terms (3-month minimum, 1 slot only).
3. **Activate sponsor** — edit `data/sponsor.yaml`: set `active: true`, `slug:`, `displayName:`, `tagline:`, `ctaUrl:`, `ctaLabel:`, `leadEmail:`, contract dates. Run `make deploy`. That's the entire rotation.
4. **Invoice + contract** — simple Stripe payment link + 1-page PDF contract (no lawyer needed for €150–300/mo).
5. **Renewal cadence** — calendar reminder 30 days before contract end. If sponsor declines renewal, pitch the next-best candidate before deactivating.

---

## Things to NOT do (reminder)

- Don't add a second sponsor slot. Single-exclusive is the model.
- Don't accept payment to change editorial rankings — disclose sponsorship visually only.
- Don't deploy from CI. `make deploy` from local Mac is the gate.
- Don't create a Google Business Profile for the directory.

---

## File map for the next executor

| What | Where |
|---|---|
| NAP source of truth | `data/studios.yaml` |
| Sponsor rotation | `data/sponsor.yaml` |
| Editorial calendar | `docs/editorial-calendar.md` |
| Backlink playbook | `docs/backlinks.md` |
| Review writing template | `docs/prompts/review-template.md` |
| Methodology page (E-E-A-T) | `content/guias/metodologia.md` |
| Decisions log | `docs/decisions.md` |
| Deploy | `make deploy` (reads `.env.deploy`) |
