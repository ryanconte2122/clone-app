# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2026-07-05

### Added
- Initial release
- URL input via Firecrawl scrape (HTML + screenshot + structured extract)
- Screenshot folder input (PNG/JPG)
- Screen recording input via ffmpeg frame extraction (MOV/MP4/WebM)
- DESIGN.md generation — color palette, typography, spacing, components, motion, brand voice
- ARCHITECTURE.md generation — screen inventory, route map, navigation graph, state map, auth model, responsive behavior, accessibility
- Next.js 16 + Tailwind v4 + shadcn/ui project bootstrap
- Per-screen Claude Sonnet 5 generation with strict design system enforcement
- Verification scaffolding (manual browser comparison)
- Optional Vercel deploy via `--target-vercel`
- Specs-only mode via `--specs-only`
- Custom slug via `--slug`
- Skip-verification via `--no-verify`
- Hermetic install — no global deps beyond Node, npm, ffmpeg (for video)
- Hermes skill integration (`SKILL.md` loads as a Hermes skill)

### Known limitations
- Stage 5 verification is manual (no automated visual diff loop yet)
- No Figma import yet (documented, not implemented)
- No HTML/JS bundle import yet (documented, not implemented)
- No parallel screen generation (single-threaded for cost control)
- macOS first; Linux/Windows untested