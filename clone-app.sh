#!/usr/bin/env bash
# clone-app — entry point for the ~/.hermes/skills/clone-app/ skill
# Usage:
#   clone-app <url>                       # clone a live URL
#   clone-app <folder>                    # clone from screenshots
#   clone-app <recording>                 # clone from a screen recording
#   clone-app --slug <name> <url>         # custom project name
#   clone-app --specs-only <url>          # DESIGN.md + ARCHITECTURE.md only, no code
#   clone-app --no-verify <url>           # skip the visual verification loop
#   clone-app --target-vercel <url>       # deploy to Vercel on success

set -euo pipefail

# ---- arg parsing (run before env check so --help works) ----
SLUG=""
SPECS_ONLY=false
NO_VERIFY=false
TARGET_VERCEL=false
INPUT=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --slug)         SLUG="$2"; shift 2 ;;
    --specs-only)   SPECS_ONLY=true; shift ;;
    --no-verify)    NO_VERIFY=true; shift ;;
    --target-vercel) TARGET_VERCEL=true; shift ;;
    -h|--help)
      sed -n '2,15p' "$0" | sed 's/^# \{0,1\}//'
      exit 0
      ;;
    *)              INPUT="$1"; shift ;;
  esac
done

[[ -z "$INPUT" ]] && { echo "usage: clone-app <url|folder|recording> [--slug name] [--specs-only] [--no-verify] [--target-vercel]"; exit 1; }

# ---- env check ----
need() { [[ -n "${!1:-}" ]] || { echo "❌ missing env: $1" >&2; exit 1; }; }
need ANTHROPIC_API_KEY
need OPENAI_API_KEY
need FIRECRAWL_API_KEY

# ---- derive slug ----
if [[ -z "$SLUG" ]]; then
  if [[ "$INPUT" =~ ^https?:// ]]; then
    SLUG=$(echo "$INPUT" | sed -E 's|^https?://||; s|/.*$||; s|\.|-|; s|^www-||')
  else
    SLUG=$(basename "$INPUT" | sed -E 's/\.[a-z]+$//' | tr ' ' '-' | tr '[:upper:]' '[:lower:]')
  fi
fi

PROJECT="$HOME/clones/$SLUG"
mkdir -p "$PROJECT/raw"

echo "🔍 clone-app starting"
echo "   input:   $INPUT"
echo "   slug:    $SLUG"
echo "   project: $PROJECT"
echo

# ---- Stage 1: CAPTURE ----
echo "📸 Stage 1: capturing..."

if [[ "$INPUT" =~ ^https?:// ]]; then
  # URL input → Firecrawl scrape
  curl -sS -X POST "https://api.firecrawl.dev/v1/scrape" \
    -H "Authorization: Bearer $FIRECRAWL_API_KEY" \
    -H "Content-Type: application/json" \
    -d "$(cat <<JSON
{
  "url": "$INPUT",
  "formats": ["html", "screenshot", "extract"],
  "onlyMainContent": false,
  "waitFor": 3000
}
JSON
)" > "$PROJECT/raw/firecrawl.json"
  echo "   ✓ Firecrawl scrape complete"

elif [[ -d "$INPUT" ]]; then
  # Folder of screenshots
  cp "$INPUT"/*.png "$PROJECT/raw/" 2>/dev/null || cp "$INPUT"/*.jpg "$PROJECT/raw/" 2>/dev/null
  echo "   ✓ copied $(ls "$PROJECT/raw/" | wc -l | tr -d ' ') screenshots"

elif [[ -f "$INPUT" && "$INPUT" =~ \.(mov|mp4|webm)$ ]]; then
  # Screen recording — extract frames at 1 fps
  if ! command -v ffmpeg >/dev/null 2>&1; then
    echo "❌ ffmpeg required for video input. install: brew install ffmpeg"
    exit 1
  fi
  ffmpeg -i "$INPUT" -vf fps=1 "$PROJECT/raw/frame-%03d.png" -y >/dev/null 2>&1
  echo "   ✓ extracted $(ls "$PROJECT/raw/"*.png | wc -l | tr -d ' ') frames"

elif [[ -d "$INPUT" ]]; then
  # HTML bundle
  cp -r "$INPUT"/* "$PROJECT/raw/"
  echo "   ✓ copied bundle"

else
  echo "❌ input not recognized as URL, folder, or recording: $INPUT"
  exit 1
fi

# ---- Stage 2 + 3: SPECS (DESIGN.md + ARCHITECTURE.md) ----
echo "📐 Stage 2-3: generating DESIGN.md + ARCHITECTURE.md..."

PROMPT_DESIGN=$(cat <<'EOF'
You are analyzing a UI for cloning. The raw data is in the `raw/` folder.

Output a DESIGN.md with:
1. Color palette — every hex code, organized by role (primary, secondary, neutral, semantic, surface)
2. Typography — font families, weights, sizes for h1-h6, body, caption, code
3. Spacing scale — base unit, all derived values (4/8/12/16/24/32/48/64)
4. Border radius scale
5. Shadow scale
6. Component inventory — every distinct UI component with: name, variants, states, props
7. Layout patterns — grid systems, max-widths, breakpoints
8. Motion patterns — transitions, easings, durations
9. Icon system — outline vs filled, weight, library if identifiable
10. Brand voice — from copy: tone, formality, jargon level

Be exhaustive. If a value is unclear, mark it ~<value>.
EOF
)

PROMPT_ARCH=$(cat <<'EOF'
You are reverse-engineering an app's UX. The raw data is in the `raw/` folder.

Output an ARCHITECTURE.md with:
1. Screen inventory — every distinct screen, with 1-sentence purpose
2. Route map — which URL pattern serves which screen
3. Navigation graph — which screens link to which
4. State map — what data each screen reads/writes, where it lives
5. Auth model — if visible: signup/login flow, protected routes
6. Empty states — what each screen looks like with zero data
7. Loading states — spinners, skeletons, optimistic UI
8. Error states — 404, 500, network failures, validation
9. Responsive behavior — what changes at mobile/tablet/desktop
10. Accessibility notes — visible a11y features

Group screens by feature area.
EOF
)

RAW_FILES=$(ls "$PROJECT/raw/" | tr '\n' ' ')
RAW_DESC="raw data files: $RAW_FILES"

# Use claude CLI for spec generation
claude -p "$PROMPT_DESIGN

$RAW_DESC

Write output to $PROJECT/DESIGN.md" --model claude-sonnet-5 >/dev/null 2>&1 || true
claude -p "$PROMPT_ARCH

$RAW_DESC

Write output to $PROJECT/ARCHITECTURE.md" --model claude-sonnet-5 >/dev/null 2>&1 || true

[[ -f "$PROJECT/DESIGN.md" ]] && echo "   ✓ DESIGN.md ($(wc -l < "$PROJECT/DESIGN.md") lines)" || echo "   ⚠ DESIGN.md not generated"
[[ -f "$PROJECT/ARCHITECTURE.md" ]] && echo "   ✓ ARCHITECTURE.md ($(wc -l < "$PROJECT/ARCHITECTURE.md") lines)" || echo "   ⚠ ARCHITECTURE.md not generated"

if $SPECS_ONLY; then
  echo
  echo "✅ Specs-only mode. Stopping after DESIGN.md + ARCHITECTURE.md"
  echo "   📂 $PROJECT"
  exit 0
fi

# ---- Stage 4: GENERATE code ----
echo "🛠  Stage 4: generating Next.js project..."

# Bootstrap Next.js
cd "$PROJECT"
npx --yes create-next-app@latest . \
  --typescript --tailwind --app --src-dir \
  --import-alias "@/*" --eslint \
  --no-turbopack --use-npm --yes >/dev/null 2>&1

# Install shadcn deps
npm install --silent >/dev/null 2>&1
npx --yes shadcn@latest init -y --base-color slate >/dev/null 2>&1 || true

echo "   ✓ Next.js + shadcn bootstrapped"

# ---- Stage 5: VERIFY (skipped if --no-verify) ----
if $NO_VERIFY; then
  echo "⏭  Stage 5: verification skipped (--no-verify)"
else
  echo "🔎 Stage 5: verification (run separately with browser)"
  echo "   To verify, run:  cd $PROJECT && npm run dev -- -p 3800"
  echo "   Then use the browser tool to screenshot + compare with raw/"
fi

# ---- Stage 6: SHIP ----
echo
echo "🚀 Stage 6: package ready"
echo "   📂 $PROJECT"
echo
echo "Next steps:"
echo "   cd $PROJECT && npm run dev"
echo "   # compare with original at $INPUT"

if $TARGET_VERCEL; then
  if [[ -z "${VERCEL_TOKEN:-}" ]]; then
    echo "⚠ VERCEL_TOKEN not set — skipping deploy"
  else
    echo "🚢 deploying to Vercel..."
    cd "$PROJECT" && vercel --prod --yes --token "$VERCEL_TOKEN" 2>&1 | tail -5
  fi
fi