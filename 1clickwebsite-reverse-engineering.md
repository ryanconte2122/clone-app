# 1ClickWebsite.ai — Reverse-Engineering Brief
## For Claude Code / Codex Agent Implementation

**Date:** 2026-07-06
**Source:** https://1clickwebsite.ai (homepage + /blog/v2-release + /blog/v2-rerelease-june-20 + /blog/best-ghl-website-alternatives + /blog/add-ghl-mcp-to-claude-desktop)
**Author:** Loki (Hermes Agent) for Ryan Conte

---

## 1. WHAT THIS PRODUCT IS

**1ClickWebsite.ai** is an AI-powered **WordPress site generator for agencies**. Single-page web app built on Next.js + Supabase. Solves one specific job: **"agency owner needs a client-ready WordPress site in 5 minutes, not 2 weeks."**

**Founder:** Bennett Black
**Tagline:** "Launch SEO Ready WordPress Sites in Minutes"
**Market:** Agency owners + marketing freelancers (NOT end-business owners)
**Pricing:** $49 / $97 / $197 / $997+ per month
**Generation speed:** ~5 minutes per site
**Output:** Real WordPress install with Breakdance (V1) or OCF (V2), structured fields, SEO-ready content, agency-white-label

**What it is NOT:** A funnel builder. A CRM. A landing-page tool. A Wix/Framer alternative. Those are competitors, not this product.

---

## 2. CORE USER FLOW (THE 3-STEP DANCE)

The entire homepage hero + product revolves around three numbered steps. This is THE conversion narrative.

```
┌──────────────────────────────────────────────────────────────────┐
│  01. CHOOSE YOUR DESIGN                                           │
│      Template picker. 8 templates visible on /create#v2 carousel  │
│      (Lightning = flagship; Pearl, Summit Sage, etc. visible).   │
│      User clicks template card → "Lightning selected" state.     │
│      Counter shows "1 / 8" position in carousel.                 │
├──────────────────────────────────────────────────────────────────┤
│  02. FILL OUT THE FORM                                            │
│      Brief intake: company name, industry, services, target      │
│      areas. ~2 minutes. Multi-step form, language picker at top.  │
│      V2 has: business details + service areas + city list.        │
├──────────────────────────────────────────────────────────────────┤
│  03. GET YOUR SITE                                                │
│      ~5 min wait → real WordPress site generated.                │
│      Three delivery options:                                       │
│        a) Download as export (zipped WP site)                     │
│        b) Migrate to own hosting (migration plugin)               │
│        c) Share temporary link with client (for agency demo)      │
└──────────────────────────────────────────────────────────────────┘
```

**This is the only flow that matters.** Every feature, every pricing tier, every testimonial maps back to "make these three steps faster."

---

## 3. FEATURE TAXONOMY (THE 12-WAY PRODUCT BREAKDOWN)

Grouped from the homepage "What's Included" + "Additional Features" sections. Each is a real, paid-included capability.

### A. Core site-generation features (every plan)
| # | Feature | V1 implementation | V2 implementation |
|---|---|---|---|
| 1 | **Meta titles & descriptions** | prewritten per page | prewritten per page (better) |
| 2 | **Lightweight, zero-bloat** | Breakdance-based, needs cache | OCF-based, lighter template system |
| 3 | **Full admin access** | WP admin credentials | WP admin credentials |
| 4 | **5-min delivery** | ~5 min | ~5 min |
| 5 | **Mobile + tablet optimized** | responsive Breakdance | responsive OCF templates |
| 6 | **100% white-label** | no 1ClickWebsite branding | no 1ClickWebsite branding |

### B. Premium add-on modules (live + beta)
| # | Module | Status | What it does | Pricing |
|---|---|---|---|---|
| 7 | **1ClickHosting** | LIVE | Managed WP hosting, custom domains, SSL, 99.9% uptime, white-label | $10/site/month |
| 8 | **LeadGen** | LIVE | CSV upload of Google businesses → batch mini demo sites for outreach | Bundled in plans (3 / 500 / 1K runs) |
| 9 | **Website Agent** | LIVE BETA | AI chat assistant that edits V2 sites (text, images, design, SEO, pages) | Bundled, with usage multipliers |

### C. The "Choose Your Design" carousel
- **V1:** Breakdance-based templates, 5+ shipped
- **V2:** OCF-based templates, 3 currently shipped, Lightning is flagship
- Templates have previews at `https://<slug>.m7q4.temphost024.com/` subdomain pattern

---

## 4. ARCHITECTURE — V1 vs V2 (THE BIG DIFFERENTIATOR)

The V2 release is the architectural north star. This is what makes the product agent-friendly, and it's the technical moat.

### V1 stack
- **Foundation:** Breakdance Pro WordPress builder
- **Plugins:** Breakdance Pro, ACF Pro, FluentSMTP, Slim SEO Pro, caching tools
- **Editing:** Mostly Breakdance visual builder or WordPress admin universal fields
- **Section design:** Manual Breakdance editing
- **Agent capabilities:** Limited — useful for service pages + service areas + global colors
- **SEO content depth:** Service pages ~500 words
- **Page weight:** Heavier (Breakdance bloat), needs more caching
- **Image gen:** Older image generation flow

### V2 stack
- **Foundation:** OCF (Own Custom Framework) — bespoke WordPress layer
- **Plugins:** OCF, FluentSMTP, Slim SEO, lighter managed stack
- **Editing:** OCF visual editor + WP admin fields + Website Agent
- **Section design:** Agent-assisted editing + section variation system
- **Agent capabilities:** Broad — text, images, design, pages, templates, blog posts, SEO fields, schema, image creation
- **SEO content depth:** Service pages ~1,200 words with stronger FAQs
- **Page weight:** Lighter template system
- **Image gen:** Newer GPT image generation, better quality
- **Light/dark mode:** Switchable via OCF settings

### Why V2 exists (verbatim from founder)
> "AI agents need a cleaner way to understand and change websites. Breakdance is powerful for humans, but it is not the easiest foundation for an AI agent to safely edit. V2 was built around a more structured system so the agent can understand what each section, field, image, page, and design setting actually does."

**This is the product thesis.** The OCF is what makes the Website Agent + Claude Code integration actually work.

### MCP integration
The site actively encourages Claude Code / Codex usage on V2 sites. From FAQ:
> "Yes. This is possible and suggested for editing V2 sites. Give your agent this link: [ADD LINK HERE]. Your agent will then know how to manipulate your site correctly once it has an application password."

So V2 sites expose a **structured agent API** (likely OCF REST endpoints + WordPress application password auth).

---

## 5. PRICING — 4 TIERS, AGENCY-OPTIMIZED

```
┌─────────────┬─────────┬──────────────┬────────────────────────────┐
│ Tier        │ Price   │ Sites/month  │ Other                       │
├─────────────┼─────────┼──────────────┼────────────────────────────┤
│ Starter     │ $49/mo  │ 3 sites      │ Website Agent              │
│             │         │              │ LeadGen Runs (unspecified)  │
│             │         │              │ Standard support            │
│             │         │              │ Export to any host          │
│             │         │              │ White-label delivery        │
├─────────────┼─────────┼──────────────┼────────────────────────────┤
│ Professional│ $97/mo  │ 10 sites     │ 3x Website Agent usage      │
│             │         │              │ 500 LeadGen Runs            │
│             │         │              │ Priority support            │
│             │         │              │ Export to any host          │
│             │         │              │ White-label delivery        │
├─────────────┼─────────┼──────────────┼────────────────────────────┤
│ Expert      │ $197/mo │ 25 sites     │ 7x Website Agent usage      │
│             │         │              │ 1K LeadGen Runs             │
│             │         │              │ Priority support            │
│             │         │              │ Export to any host          │
│             │         │              │ White-label delivery        │
├─────────────┼─────────┼──────────────┼────────────────────────────┤
│ Agency V2   │ $997+   │ Unlimited    │ Unlimited sites             │
│ (cal.com)   │         │              │ Unlimited lead gen          │
│             │         │              │ BYO AI keys                 │
│             │         │              │ Team members                │
│             │         │              │ Full white-label            │
└─────────────┴─────────┴──────────────┴────────────────────────────┘
```

**Annual:** 3 months free.
**Checkout:** Stripe.
**All plans include:** Hosting export, white-label delivery, Website Agent (with multipliers).

**The value ladder per site:**
- Starter: $16/site (3 sites for $49)
- Professional: $9.70/site (10 sites for $97)
- Expert: $7.88/site (25 sites for $197)
- Agency: unbounded (volume play)

**If agency sells site for $2,000** (their stated customer target): Expert tier = 0.4% COGS. Even at $500/site, 1.6% COGS. The economics are absurd.

---

## 6. THE COMPETITIVE POSITIONING (FROM THEIR OWN BLOG)

| Rank | Competitor | What 1ClickWebsite.ai says |
|---|---|---|
| 1 | **1ClickWebsite.ai** | Best GHL alternative for full client sites |
| 2 | **Duda** | Hosted white-label builder, not WordPress |
| 3 | **Wix Studio** | Visual design control, slower |
| 4 | **10Web** | AI WordPress starter, more shaping needed |
| 5 | **Framer** | Design-focused, not local-SEO |
| 6 | **Manual WP (Elementor/Breakdance/OptimizePress)** | Flexible but slow |

**Their wedge against GHL (GoHighLevel):** "GHL is fine for CRM/pipeline. It's slow for client website builds. Use GHL for the CRM, use 1ClickWebsite.ai for the site."

**Their wedge against Duda/Framer/Wix Studio:** "Those aren't WordPress. If your clients expect WordPress (and most do for SEO/ownership), we're the only AI builder that ships a real WP site."

**Their wedge against manual WordPress:** "We give you a useful first draft in 5 minutes. You polish the parts that need judgment (offer, copy, images). We don't replace designers — we replace the blank page."

---

## 7. TARGET MARKET PSYCHOGRAPHICS

From the testimonials, FAQ, and the founder's blog voice:

| Trait | Evidence |
|---|---|
| **Has agency clients paying $500–$5,000/site** | Repeated: "sold 6 sites in 30 days", "$500/mo clients through DMs", "$2,000–$5,000 range" |
| **Was building sites in 1-2 weeks before** | Repeated: "used to build sites for weeks" |
| **Frustrated with GHL website builder specifically** | Entire 9-min blog post on GHL alternatives |
| **Wants speed, not maximalism** | "Useful first draft in minutes" is the recurring promise |
| **Owns WordPress or wants to** | "Why is WordPress a big deal?" is an FAQ — they assume the audience knows it is |
| **Sales via DM/cold outreach** | LeadGen tool exists exactly for this |
| **Skeptical of AI tools** | Reviews emphasize "real WordPress", "SEO friendly", "not bloated" |
| **Building 3-25 sites/month** | All three paid tiers sit in this range |

**Negative persona (who this is NOT for):**
- Solo founders building their own site (use Framer, Carrd, WordPress.com)
- Enterprise teams (use Webflow, custom Next.js)
- Bloggers / content sites (use Ghost, Substack)
- eCommerce (use Shopify)

---

## 8. BRAND VOICE (FROM THE COPY)

Direct, no-BS, founder-led. Bennett Black writes in first person on the blog. Tone is conversational but informed.

**Recurring vocabulary:**
- "agency owners", "agency-ready", "client-ready"
- "5 minutes", "useful first draft"
- "ownership", "WordPress", "SEO structure"
- "client handoff", "white-label"
- "agent-assisted", "agent-friendly"
- "the slow part", "the blank page"

**Tone anti-patterns (they avoid):**
- "AI-powered" (used minimally)
- "10x your workflow"
- "Revolutionary"
- "Game-changing" (yes they say it in testimonials, but the founder avoids it)
- "All-in-one"

**Signature line:** "If the thing you want is a better way to build client websites than GHL Website Builder or GHL AI Studio, start with 1ClickWebsite.ai."

---

## 9. TECH STACK INFERENCES (FOR BUILDING A CLONE)

| Layer | Likely tech | Evidence |
|---|---|---|
| **Frontend** | Next.js + React + Tailwind CSS | Homepage shows Next.js image proxy patterns; CSS classes match Tailwind |
| **Backend** | Supabase (Postgres + Storage + Auth) | Image URLs all go to `qmunvayuwpybejjrtvjc.supabase.co/storage/v1/object/public/...` |
| **Storage** | Supabase Storage buckets: `reviews`, `Generated Sites`, `template-images`, `blog` | URL patterns |
| **Payments** | Stripe | "Secure checkout powered by Stripe" |
| **Demo hosting** | `*.m7q4.temphost024.com` subdomain pattern | Template preview URLs |
| **AI generation** | OpenAI GPT image gen + Claude (V2 agent) | Confirmed via blog |
| **Email** | FluentSMTP on generated WP sites | Plugin name appears in stack |
| **SEO on generated sites** | Slim SEO | Plugin name appears in stack |
| **V1 builder** | Breakdance Pro | Plugin name appears in stack |
| **V2 builder** | OCF (custom plugin) | Founder blog |
| **Calendar/booking** | cal.com | Agency plan CTA links there |
| **Blog** | Custom (not Ghost/Substack) | `/blog/<slug>` URL pattern + Vercel-style pages |
| **Analytics** | Unknown | Not visible in scrape |
| **CDN** | Cloudflare likely | `_next/image` proxy pattern + Supabase CDN |

**Database schema inferred (Supabase Postgres):**
- `users` (agency owner accounts)
- `sites` (generated WP site records, slug, template_id, status)
- `subscriptions` (Stripe-linked, tier, sites_remaining)
- `leads` (LeadGen CSV uploads)
- `templates` (template metadata, preview_url)
- `blog_posts` (CMS)
- `reviews` (testimonials)
- `payments` (Stripe events log)

---

## 10. PAGE INVENTORY (WEBSITE)

| Path | Purpose | Type |
|---|---|---|
| `/` | Marketing homepage | Static SSG |
| `/create` | Site generation flow (with `#v1` / `#v2` hash toggle) | Dynamic SPA-like |
| `/create#v1` | V1 builder picker | Dynamic |
| `/create#v2` | V2 builder picker (Lightning flagship) | Dynamic |
| `/pricing` | 404'd at scrape time, but content is in homepage | — |
| `/about` | 404 | — |
| `/blog` | Blog index | SSG |
| `/blog/v2-release` | V2 release notes | SSG |
| `/blog/v2-rerelease-june-20` | V2 re-release announcement | SSG |
| `/blog/best-ghl-website-alternatives` | SEO competitor piece | SSG |
| `/blog/add-ghl-mcp-to-claude-desktop` | Tutorial | SSG |
| `/signup` / `/login` | Auth (Stripe Customer Portal) | Dynamic |
| `/dashboard` | Post-login user area (assumed) | Dynamic |
| `/dashboard/sites` | List of generated sites (assumed) | Dynamic |
| `/dashboard/sites/<id>` | Site detail + Website Agent | Dynamic |
| `/dashboard/leads` | LeadGen CSV uploads + results | Dynamic |
| `/dashboard/billing` | Stripe portal | Dynamic |
| `/dashboard/agent` | Website Agent chat interface | Dynamic |
| `/support` | Support portal (referenced in testimonials) | Dynamic |

**Auth model:** Supabase Auth + Stripe Customer (linked via Stripe customer ID).

---

## 11. KEY METRICS (CLAIMED)

From homepage + testimonials:

- **5,000+ sites generated** (homepage badge)
- **Trusted by agency owners** (homepage badge)
- **~5 minutes per site** (homepage hero + multiple testimonials)
- **3,000+ leads/month potential** at Expert tier (1K LeadGen Runs/month)
- **Average customer:** "I've already sold 6 websites in the last 30 days" (testimonial)

---

## 12. WHAT TO BUILD (CLONE BRIEF FOR CLAUDE CODE)

If you're cloning this, here's the MVP in order of priority:

### Tier 1 — MVP (ship in 30 days)
1. **Template picker** (carousel, 3-5 templates minimum)
2. **Intake form** (business name, industry, services, city, language)
3. **Generation engine** (LLM call → WordPress install with Breakdance or custom blocks)
4. **Three delivery options** (download .zip / temp link / migrate to user hosting)
5. **Stripe subscription** (3 tiers: $49 / $97 / $197)
6. **User dashboard** (sites list + status + download links)

### Tier 2 — V2 equivalent (months 2-3)
7. **OCF-style structured editing layer** (sections as JSON, not as builder blobs)
8. **Website Agent chat** (Claude API editing structured sections)
9. **Section variation system** (multiple variants per section type)
10. **Light/dark mode toggle** (theme.json-level, not CSS hack)

### Tier 3 — Growth features (months 4+)
11. **LeadGen CSV upload** (batch mini sites for outreach)
12. **Managed hosting** ($10/site/month add-on)
13. **Claude Code MCP server** (expose OCF endpoints as agent tools)
14. **Multi-language support** (English, Spanish, French, German, Italian, Romanian, Turkish)

### Tier 4 — Moat (months 6+)
15. **Bring-your-own AI keys** (agency controls which model)
16. **Team member seats** (multi-user agency accounts)
17. **Full white-label** (custom domain, custom branding throughout)
18. **Affiliate / reseller program**

---

## 13. WHAT MAKES THIS HARD TO CLONE

1. **The generation quality.** Anyone can wrap an LLM. The moat is the prompts, the templates, the structured sections. 1ClickWebsite.ai clearly has hundreds of hours of prompt + template tuning.
2. **The exportability.** Real WordPress export with proper image handling, DB dumps, plugin compatibility — this is engineering depth.
3. **The SEO structure.** Prewritten meta titles, descriptions, schema, sitemap, service + location pages — this is content systems work, not AI work.
4. **The agent integration.** OCF's structured fields are the moat that lets the Website Agent actually work. Most "AI website builders" don't have this layer.
5. **The hosting handoff.** Migrating a generated site to your own hosting cleanly is non-trivial. Migration plugin support is a real engineering surface.

---

## 14. OPEN QUESTIONS (CAN'T VERIFY WITHOUT LOGIN)

- What's in the OCF plugin specifically? (section types, field types, REST API surface)
- What's the actual generation pipeline? (parallel LLM calls? single mega-prompt? post-processing?)
- How does the temp hosting subdomain work? (`*.temphost024.com` pattern — fleet of small VPS?)
- What's the cost-per-generation? (GPT-image + Claude tokens + compute)
- How is the V2 Website Agent's context window managed? (full page DOM? section-level?)
- What does the support portal look like? (referenced as "outstanding" in testimonials)
- What's the agency dashboard analytics? (sites generated, leads converted, MRR per agency?)

---

## 15. END

**One-line summary for Claude Code:**

Build an AI WordPress site generator for agencies. Template picker → intake form → 5-min generation → real WordPress site → export or temp-link demo. The moat is structured sections (OCF-style) so an AI agent can edit generated sites safely. Sell to agencies at $49-197/mo who sell sites to local businesses at $500-5,000.

---

**Sources:**
- https://1clickwebsite.ai/ (homepage, 25k chars)
- https://1clickwebsite.ai/blog/v2-release (V1 vs V2 architecture spec)
- https://1clickwebsite.ai/blog/v2-rerelease-june-20 (V2 re-release announcement)
- https://1clickwebsite.ai/blog/best-ghl-website-alternatives (competitive positioning)
- https://1clickwebsite.ai/blog/add-ghl-mcp-to-claude-desktop (MCP integration tutorial)