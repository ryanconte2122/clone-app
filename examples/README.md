# Examples

## Example 1: Clone a marketing site (fast, specs-only)

```bash
clone-app https://stripe.com/pricing --slug stripe-pricing --specs-only
```

Output: `~/clones/stripe-pricing/` with `DESIGN.md` and `ARCHITECTURE.md` only. No code generation. Use this when you want to study the design system of a competitor before writing your own.

## Example 2: Clone a SaaS app dashboard (full pipeline)

```bash
clone-app https://linear.app --slug linear-clone
```

Then iterate:

```bash
cd ~/clones/linear-clone
npm run dev -- -p 3800
# open http://localhost:3800
# screenshot both, compare, iterate via:
claude -p "Compare raw/ and current src/. For each screen that differs >5%, regenerate the screen. Use DESIGN.md and ARCHITECTURE.md as reference."
```

## Example 3: Clone from a screen recording

```bash
# Walk through your target app with QuickTime / ScreenFlow / OBS
# Save to ~/Movies/walkthrough.mov
clone-app ~/Movies/walkthrough.mov --slug my-app
```

## Example 4: Deploy to Vercel on success

```bash
clone-app https://notion.so --slug notion-clone --target-vercel
# → outputs: https://notion-clone-<hash>.vercel.app
```

## Example 5: Batch clone (queue-based)

```bash
# Drop URLs into a queue file
cat > ~/clone-queue.txt <<EOF
https://stripe.com
https://linear.app
https://vercel.com
EOF

# Process them
while read url; do
  slug=$(echo "$url" | sed 's|https://||; s|/.*||; s|\.|-|')
  clone-app "$url" --slug "$slug" --no-verify
done < ~/clone-queue.txt
```

## Output structure (any example)

```
~/clones/<slug>/
├── raw/                  # Firecrawl dump / screenshots / extracted frames
│   ├── firecrawl.json
│   └── frame-001.png ... (for video input)
├── DESIGN.md             # 50-200 lines: colors, type, components, spacing
├── ARCHITECTURE.md       # 30-150 lines: screens, routes, state, auth
├── src/                  # Complete Next.js app
│   ├── app/
│   │   ├── page.tsx
│   │   ├── pricing/page.tsx
│   │   └── ...
│   ├── components/
│   ├── lib/
│   └── ...
├── VERIFY.md             # (after manual browser comparison)
├── package.json
├── tsconfig.json
└── .env.example
```