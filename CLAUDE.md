# MC Tracker — project notes for Claude

Troy Morgan's client, outreach and hours tracker for Morgan Creative (his solo brand and web design studio). Troy is a designer, not a developer: explain changes in plain language and keep his effort to a minimum.

## How it's built
- A single-page app: `index.html` holds all the markup, CSS and JS. Keep it that way. No build step and no frameworks.
- Hosted on GitHub Pages from `main` at https://charmingchewbacca.github.io/mc-tracker/. Anything pushed to `main` goes live within a minute or two.
- Data lives in Supabase: one private row per user in `public.crm_state` (`data` jsonb, `version` bigint), protected by row-level security. See `supabase-setup.sql`.
- `config.js` holds the Supabase URL and publishable key. Both are public by design. Never add a secret or service_role key.
- `supabase.js` is the Supabase library bundled locally (no CDN).
- `fonts/` holds Nunito Sans (Troy's brand typeface) as local woff2 files, with its OFL licence. No Google Fonts request.
- `.github/workflows/keep-awake.yml` pings the database every 3 days so the free plan doesn't pause.
- Saves use optimistic versioning with a record-by-record three-way merge (`mergeThreeWay`), so phone and Mac edits don't overwrite each other. Don't break this.
- Dates must use local time (`today()`, `localDate()`, `parseLocal()`), never `toISOString().slice(0,10)`.

## Privacy rules
- Never commit client data, backups (`.json`) or screenshots containing client info to this public repo.
- Use made-up sample data when testing (the app has "Load sample data").
- Client Info passwords: masked by default, revealed with the eye, never included in "Copy All". Client Info inputs carry `NOFILL` attributes so 1Password and browsers don't autofill or offer to save.

## Design rules (Troy cares about these)
- Corner radius: 0.45rem on buttons and badges, 0.7rem on cards and large elements (including the floating button).
- No emoji anywhere in the interface. Use SVG icons.
- Stat colours: green = money, blue = active clients, gold = outreach, neutral = hours. Stat boxes are white; colour goes on the number only. Total Hours is the one dark box.
- Surfaces: page #F6F6F3, cards white with a 1px #E6E6E1 border and a faint shadow. No beige tints. Blue is for actions and links.
- Client cards show payment progress as a 4-segment bar (`payBarHtml`) instead of an invoice badge.
- Lean and uncluttered beats feature-rich. Ask before adding complexity.
- Phone (≤700px): stats in a 2-column grid; a floating button changes with the tab (Add Client / Add Prospect / Log Hours) and replaces the static tab buttons; the hours log is compact rows with no sideways scrolling; inputs use 16px to stop iPhone zoom.
- Visually line up icons with text edges, not with their invisible tap areas.

## Business logic
- Billing: 50% deposit, then 50% final. Invoice statuses: Not Invoiced → Deposit Invoiced (id `invoiced`) → Deposit Paid → Final Invoiced → Paid in Full (id `paid`). Paid to Date counts 50% at deposit paid and 100% at paid in full.
- Clients sort: follow-up first, then paid before volunteer, then most hours. Hours tab client cards: most hours first.

## Before finishing any change
- Check it at phone width (390px) and desktop width.
- Make sure there are no console errors and that saving still syncs.
- Tell Troy in a sentence or two what changed and what to check on his phone.
