---
name: clone-app
description: >
  Scan a web app or screenshot and produce a working Next.js clone. Takes a
  live URL (Firecrawl), a folder of screenshots (GPT-4-Vision), or a
  screen recording (Hermes browser capture). Pipeline: capture → extract →
  understand (Claude Sonnet 5) → generate code → verify side-by-side →
  output as a runnable Next.js project in `~/clones/<slug>/`. Triggers on
  "clone this app", "rebuild [url]", "make a clone of", "scan and recreate",
  "copy this UI", "reproduce this site", "screenshot to code", "URL to code".
version: 1.0.0
author: Loki (Hermes Agent)
license: MIT
tags: [ui-clone, screenshot-to-code, url-to-code, firecrawl, vision, nextjs, frontend]
platforms: [macos]
---

# Clone App — UI-to-Code Pipeline

Turn any web app, screenshot, or screen recording into a working Next.js clone.
Goal is **85-95% visual parity on first pass**, with iterative refinement loops
to push higher.

## What this skill does NOT do

- **Backend / business logic** — UI only. Auth, payments, databases not cloned.
- **Native mobile binaries** (iOS/Android APKs) — different tool class.
- **DRM'd / heavily-obfuscated apps** — needs DOM access.
- **Pixel-perfect** — first pass is 85-95% match. Iterate to refine.

## Inputs (pick ONE)

| Input | Path | Best for |
|---|---|---|
| **Live URL** | `https://app.example.com` | Public web apps, marketing sites, dashboards |
| **Screenshot folder** | `~/Pictures/clone-target/*.png` | Apps behind login, mobile-only, native UI |
| **Screen recording** | `~/Movies/clone-target.mov` | Multi-page apps, animations, transitions |
| **Existing HTML/JS bundle** | `~/Downloads/app-bundle/` | Source-code available but needs React conversion |

## Outputs

- **Project dir:** `~/clones/<slug>/` — full Next.js 16 app with shadcn/ui + Tailwind
- **Design spec:** `~/clones/<slug>/DESIGN.md` — colors, type, components, spacing
- **Architecture spec:** `~/clones/<slug>/ARCHITECTURE.md` — screens, routes, state
- **Verification report:** `~/clones/<slug>/VERIFY.md` — side-by-side diff notes
- **Optional deploy:** Vercel preview URL if `VERCEL_TOKEN` env is set

## Required environment

```bash
ANTHROPIC_API_KEY=sk-ant-...   # Claude Sonnet 5 — REQUIRED
OPENAI_API_KEY=sk-pro-...      # GPT-4-Vision — REQUIRED for screenshot/recording input
FIRECRAWL_API_KEY=fc-...       # Firecrawl — REQUIRED for URL input
VERCEL_TOKEN=...               # Vercel — OPTIONAL for deploy
```

If any REQUIRED key is missing, stop and tell the user which one.

## The Pipeline (6 stages)

### Stage 1: CAPTURE — get the visual + structural data

**URL input** → Firecrawl `/scrape` with `formats: ["html", "screenshot", "extract"]` and
`onlyMainContent: false`. Also crawl up to 20 subpages if it's an SPA dashboard.

**Screenshot folder** → GPT-4-Vision on each PNG. Batch in groups of 5 to control cost.

**Screen recording** → Extract frames at 1 fps via ffmpeg → analyze first/last/key frames
(when user pauses/clicks) with GPT-4-Vision.

**HTML bundle** → Read with `read_file`, no extraction needed.

Save raw data to `~/clones/<slug>/raw/`:
- `home.html`, `dashboard.html`, etc. (URL input)
- `frame-001.png`, `frame-002.png`, ... (screenshot/recording input)
- `bundle/index.html`, `bundle/main.js` (HTML input)

### Stage 2: EXTRACT — pull design tokens + component inventory

Fire this prompt at Claude Sonnet 5:

```
You are analyzing a UI for cloning. Input: <raw data paths>.

Output a DESIGN.md with:
1. Color palette — every hex code, organized by role (primary, secondary, neutral, semantic, surface)
2. Typography — font families, weights, sizes for h1-h6, body, caption, code
3. Spacing scale — base unit, all derived values (4/8/12/16/24/32/48/64)
4. Border radius scale
5. Shadow scale
6. Component inventory — every distinct UI component with: name, variants, states (default/hover/active/disabled/loading/error), props
7. Layout patterns — grid systems, max-widths, breakpoints
8. Motion patterns — transitions, easings, durations
9. Icon system — outline vs filled, weight, library if identifiable
10. Brand voice — from copy: tone, formality, jargon level

Be exhaustive. If a value is unclear, mark it `~<value>` (approximate).
```

### Stage 3: UNDERSTAND — map screens → routes → state

Same model, separate prompt:

```
You are reverse-engineering an app's UX. Input: <raw data + DESIGN.md>.

Output an ARCHITECTURE.md with:
1. Screen inventory — every distinct screen, with a 1-sentence purpose
2. Route map — which URL pattern serves which screen
3. Navigation graph — which screens link to which
4. State map — what data each screen reads/writes, where it lives (URL params, localStorage, server, etc.)
5. Auth model — if visible: signup/login flow, protected routes, roles
6. Empty states — what each screen looks like with zero data
7. Loading states — spinners, skeletons, optimistic UI patterns
8. Error states — 404, 500, network failures, validation
9. Responsive behavior — what changes at mobile/tablet/desktop
10. Accessibility notes — visible a11y features (focus rings, ARIA, contrast)

For multi-page apps, group screens by feature area.
```

### Stage 4: GENERATE — produce complete Next.js code

Single Sonnet 5 call per screen. For a typical app (10-15 screens), this is 10-15 calls,
each ~30-60 seconds. **Use opus for the design system + layout shells, sonnet for individual
screens, haiku for boilerplate.**

Master prompt template:

```
Build a Next.js 16 (App Router) page that exactly matches this design.

DESIGN SYSTEM: <paste DESIGN.md>
SCREEN: <screen name>
PURPOSE: <from ARCHITECTURE.md>
REFERENCE: <raw screenshot or URL of original>

Requirements:
- App Router (src/app/<route>/page.tsx)
- Tailwind CSS v4 (use @theme inline for design tokens)
- shadcn/ui components only — no custom primitives
- TypeScript strict mode
- Server Components by default; Client Components only for interactive parts
- All states present: default, hover, active, focus-visible, disabled, loading (skeleton), empty, error
- Responsive: mobile-first, breakpoints at sm/md/lg/xl/2xl from the original
- Semantic HTML: <main>, <nav>, <section>, <article>, <aside>
- Accessibility: focus rings, aria-labels, contrast ratios >= WCAG AA
- No placeholder text. No "lorem ipsum". Use realistic content from the original.
- No emoji in code. No #000000. No h-screen (use min-h-[100dvh]).

Output the complete file. No "...". No "rest of the code". No TODOs.
```

Repeat for every screen in ARCHITECTURE.md.

### Stage 5: VERIFY — side-by-side visual diff

```bash
# 1. Spin up the local dev server
cd ~/clones/<slug> && npm install && npm run dev -- -p 3800 &

# 2. Use Hermes browser to screenshot every route at desktop (1440x900) + mobile (390x844)
# 3. Use GPT-4-Vision to compare each clone screenshot vs original
# 4. For each diff >5%, regenerate that screen with explicit fix instructions
```

Verification prompt:

```
Compare these two screenshots. Original: <original.png>. Clone: <clone.png>.

Output a VERIFY.md with:
- Overall match score (0-100%)
- Per-region diff: header, hero, navigation, content, footer
- For each region with >5% diff: specific change instructions (color hex, size, position)
- Accessibility issues you can spot
- Layout shifts or alignment problems

Be ruthless. "Looks close" is not a passing grade.
```

Loop back to Stage 4 until score >= 90 or 3 iterations complete.

### Stage 6: SHIP — package and (optionally) deploy

```bash
# 1. Write package.json with all needed deps
# 2. Write README.md with setup instructions
# 3. Write tsconfig.json + tailwind.config.ts + postcss.config.mjs
# 4. Write .env.example with all env vars used
# 5. Write components.json (shadcn config)

# Optional Vercel deploy:
cd ~/clones/<slug> && vercel --prod --yes
```

## Cost estimate (typical 15-screen app)

| Stage | Cost |
|---|---|
| Firecrawl scrape (20 pages) | ~$0.50 |
| GPT-4-Vision (50 frames) | ~$1.50 |
| Claude Sonnet 5 (15 screen generations @ 4k tokens each) | ~$3.00 |
| Verification iterations (2-3 loops) | ~$1.50 |
| **Total** | **~$6.50 per app** |

Single-user mode. No parallelism. ~15-25 minutes wall time for a 15-screen app.

## Commands

```bash
# Invoke from main session
clone-app https://linear.app

# Or with a screenshot folder
clone-app ~/Pictures/linear-clone/

# Or with explicit slug
clone-app https://linear.app --slug linear-clone --target-vercel

# Dry run (no code generation, just specs)
clone-app https://linear.app --specs-only

# Skip verification (faster, no iteration)
clone-app https://linear.app --no-verify
```

## Common pitfalls

- **JS-rendered SPAs need Firecrawl's `waitFor` selector** — set to `.app-loaded` or 3000ms
- **Auth-walled apps** can't be cloned from URL — user must supply screenshots from inside
- **Tailwind v4 uses @theme inline, not config file** — use the new syntax
- **shadcn/ui requires manual install per project** — `npx shadcn@latest init` then `npx shadcn@latest add <component>`
- **Animations need 'use client' + Framer Motion** — but only for animated components
- **Long pages need 'use client' for scroll-based effects** — but only the wrapper
- **Color contrast is often wrong in clones** — always run a contrast check in Stage 5
- **Fonts from CDN may be rate-limited** — fallback to system-ui if Google Fonts fails
- **Image-heavy sites get huge** — extract `<img src>` URLs, download with curl, store in /public

## What to do when this skill returns

When user says "clone X":

1. Validate input (URL or folder exists)
2. Check env vars (ANTHROPIC, OPENAI, FIRECRAWL — fail fast if missing)
3. Create `~/clones/<slug>/` and `~/clones/<slug>/raw/`
4. Run Stages 1-6 sequentially
5. Report final score + Vercel URL (if deployed) + project location

## Related skills

- **taste-skill** — load when generating components to enforce design quality
- **output-skill** — load to ban placeholder patterns in generated code
- **distinctive-frontend** — load to avoid generic AI aesthetics in the clone
- **pre-meeting-site-builder** — use this instead if the input is a marketing site, not an app
- **craftpulse-dispatch** — load if user wants the clone deployed as part of a CraftPulse pipeline

## Versioning

- v1.0.0 — Initial release. URL + screenshot + recording + bundle inputs. Next.js 16. Sonnet 5 + GPT-4V. Single-user mode.