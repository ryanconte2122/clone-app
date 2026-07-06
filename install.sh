#!/usr/bin/env bash
# clone-app installer
set -euo pipefail

REPO_DIR="$(cd "$(dirname "$0")" && pwd)"
SKILL_DIR="$HOME/.hermes/skills/clone-app"

echo "🔧 clone-app installer"
echo "   repo:  $REPO_DIR"
echo

# 1. Symlink the runner onto PATH
mkdir -p "$HOME/.local/bin"
ln -sf "$REPO_DIR/clone-app.sh" "$HOME/.local/bin/clone-app"
echo "✓ linked ~/.local/bin/clone-app → $REPO_DIR/clone-app.sh"

# 2. Optionally install as a Hermes skill
if [[ -d "$HOME/.hermes" ]]; then
  mkdir -p "$SKILL_DIR"
  cp "$REPO_DIR/SKILL.md" "$SKILL_DIR/"
  cp "$REPO_DIR/clone-app.sh" "$SKILL_DIR/"
  chmod +x "$SKILL_DIR/clone-app.sh"
  echo "✓ installed as Hermes skill at $SKILL_DIR"
else
  echo "○ no ~/.hermes/ found, skipped skill install"
fi

# 3. Env check
echo
echo "🔑 env check:"
MISSING=0
for var in ANTHROPIC_API_KEY OPENAI_API_KEY FIRECRAWL_API_KEY; do
  if [[ -n "${!var:-}" ]]; then
    echo "  ✓ $var set"
  else
    echo "  ✗ $var missing"
    MISSING=$((MISSING+1))
  fi
done
if [[ -n "${VERCEL_TOKEN:-}" ]]; then
  echo "  ✓ VERCEL_TOKEN set"
else
  echo "  ○ VERCEL_TOKEN missing (optional, needed for --target-vercel)"
fi

echo
if [[ $MISSING -gt 0 ]]; then
  echo "⚠ $MISSING required env var(s) missing. clone-app will fail until they're set."
  echo "  Add them to ~/.hermes/.env or your shell rc."
fi

echo
echo "✅ install complete. try:"
echo "   clone-app --help"
echo "   clone-app https://stripe.com/pricing --slug stripe-test --specs-only"