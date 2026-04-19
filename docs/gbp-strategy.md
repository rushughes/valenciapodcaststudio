# Google Business Profile strategy

## Why we do NOT create a GBP for this directory

Google Business Profile is for businesses with a physical location where customers visit. A directory website with no storefront violates Google's guidelines if it creates a GBP for the directory itself. Doing so risks:

- Profile suspension
- Manual action on the entire domain
- Loss of ranking trust

**Do not create a GBP for valenciapodcaststudio.com.**

## What we do instead for GBP

1. **Encourage sponsors to optimise their own GBP.** When a studio becomes Patrocinador #1, include a one-pager in the onboarding pack with tips:
   - Complete all GBP categories and attributes
   - Add high-quality photos (interior, equipment, team)
   - Enable Q&A and respond to every review within 24h
   - Use the "Posts" feature to promote new services or offers

2. **Link to their GBP from our review page.** The `googleMapsUrl` field in `data/studios.yaml` populates a "Ver en Google Maps" link on each studio page. This is a quality outbound signal.

3. **Citations on third-party directories** — these point to our domain as an editorial source, not to a GBP. See `docs/backlinks.md`.

## How studios get discovered through local search without our GBP

Our schema.org `LocalBusiness` markup on each studio page surfaces studio NAP directly in Google's Knowledge Panel via structured data — without needing our own GBP. The `ItemList` schema on the ranking page can also trigger rich results.
