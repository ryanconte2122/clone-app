# clone-app

> **Scan any web app or screenshot and produce a working Next.js clone.**

Turn a live URL, a folder of screenshots, or a screen recording into a runnable
Next.js 16 project with shadcn/ui + Tailwind v4. Pipeline: capture → extract →
understand (Claude Sonnet 5) → generate code → verify side-by-side → ship.

```
$ clone-app https://linear.app
📸 Stage 1: capturing...   ✓ Firecrawl scrape complete
📐 Stage 2-3: generating... ✓ DESIGN.md (162 lines), ARCHITECTURE.md (89 lines)
🛠  Stage 4: generating...  ✓ Next.js + shadcn bootstrapped
🔎 Stage 5: verification    (run browser comparison)
🚀 Stage 6: package ready   📂 ~/clones/linear/

$ cd ~/clones/linear && npm run dev
# → http://localhost:3000 — running clone
```

## Install

Requires macOS, Node 20+, and these API keys in your environment:

```bash
export ANTHROPIC_API_KEY=sk-ant-...   # Claude Sonnet 5
export OPENAI_API_KEY=sk-pro-...      # GPT-4-Vision
export FIRECRAWL_API_KEY=fc-...       # URL scraping
export VERCEL_TOKEN=...               # Optional, for --target-vercel
```

Clone the repo and run the installer:

```bash
git clone https://github.com/ryanconte2122/clone-app.git ~/code/clone-app
cd ~/code/clone-app
./install.sh
```

Or manually:

```bash
# Symlink the runner
ln -sf "$(pwd)/clone-app.sh" ~/.local/bin/clone-app

# As a Hermes skill (optional)
cp SKILL.md ~/.hermes/skills/clone-app/
cp clone-app.sh ~/.hermes/skills/clone-app/
chmod +x ~/.hermes/skills/clone-app/clone-app.sh
```

## Usage

```bash
# Live URL
clone-app https://linear.app

# Screenshot folder (PNG or JPG)
clone-app ~/Pictures/linear-clone/

# Screen recording (MOV/MP4/WebM, requires ffmpeg)
clone-app ~/Movies/linear-walkthrough.mov

# Custom project name
clone-app https://linear.app --slug my-linear

# Specs only (DESIGN.md + ARCHITECTURE.md, no code)
clone-app https://linear.app --specs-only

# Skip verification (faster, no iteration)
clone-app https://linear.app --no-verify

# Deploy to Vercel when done
clone-app https://linear.app --target-vercel
```

## What you get

```
~/clones/<slug>/
├── raw/              # Firecrawl dump / screenshots / extracted frames
├── DESIGN.md         # colors, type, components, spacing, motion
├── ARCHITECTURE.md   # screens, routes, state, auth, responsive
├── src/              # Next.js 16 + Tailwind v4 + shadcn/ui
├── VERIFY.md         # visual diff report (manual)
└── package.json
```

## The pipeline (6 stages)

| Stage | What | Tool |
|---|---|---|
| 1. CAPTURE | Get visual + structural data | Firecrawl / copy / ffmpeg |
| 2. EXTRACT | Pull design tokens | Claude Sonnet 5 |
| 3. UNDERSTAND | Map screens → routes → state | Claude Sonnet 5 |
| 4. GENERATE | Build complete Next.js code | Claude Sonnet 5 + create-next-app + shadcn |
| 5. VERIFY | Side-by-side visual diff | Browser tool + GPT-4-Vision |
| 6. SHIP | Package + optional Vercel deploy | vercel CLI |

## Cost & time

| App size | Time | Cost |
|---|---|---|
| Marketing site (3-5 screens) | ~5 min | ~$1.50 |
| Standard app (10-15 screens) | ~20 min | ~$6.50 |
| Heavy app (30+ screens) | ~45 min | ~$15 |

## What this does NOT do

- Backend / business logic — UI only
- Native mobile binaries (iOS / Android APKs)
- DRM'd or heavily obfuscated apps
- Pixel-perfect on first pass (85-95% match; iterate to refine)

## Why this exists

Existing tools either clone the DOM only (Firecrawl alone), or generate from a
screenshot without understanding the structure (screenshot-to-code), or work
single-screen at a time (v0, Bolt, Lovable). `clone-app` chains them together
with explicit design + architecture specs, so you can iterate on the **system**
not just one page.

## Requirements

- macOS (Linux should work; Windows untested)
- Node.js 20+
- `npx` on PATH
- `ffmpeg` (only for screen recording input): `brew install ffmpeg`
- API keys (see Install)

## Development

```bash
# Run on a real URL
./clone-app.sh https://stripe.com/pricing --slug stripe-pricing --specs-only

# Iterate
cd ~/clones/stripe-pricing
npm run dev -- -p 3800
# Open http://localhost:3800, screenshot, compare to https://stripe.com/pricing
```

## License

MIT © Ryan Conte

## Related

- [screenshot-to-code](https://github.com/abi/screenshot-to-code) — the open-source inspiration
- [Firecrawl](https://firecrawl.dev) — web scraping
- [shadcn/ui](https://ui.shadcn.com) — components
- [Taste Skill](https://github.com/ryanconte2122/taste-skill) — design rules