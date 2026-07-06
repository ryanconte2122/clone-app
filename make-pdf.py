#!/usr/bin/env python3
"""Convert the reverse-engineering markdown to a styled, print-ready PDF via Chrome headless."""
import sys, subprocess, os
from pathlib import Path
import markdown

repo = Path("/Users/thorbot/clone-app-repo")
md_path = repo / "1clickwebsite-reverse-engineering.md"
html_path = repo / "1clickwebsite-reverse-engineering.html"
pdf_path = repo / "1clickwebsite-reverse-engineering.pdf"

md_text = md_path.read_text(encoding="utf-8")

# Convert markdown → HTML with extras for tables
html_body = markdown.markdown(
    md_text,
    extensions=["tables", "fenced_code", "toc", "sane_lists"],
)

# Wrap in styled HTML
html_full = f"""<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8" />
<title>1ClickWebsite.ai — Reverse-Engineering Brief</title>
<style>
  @page {{
    size: Letter;
    margin: 0.6in 0.5in 0.7in 0.5in;
    @bottom-center {{
      content: "Page " counter(page) " of " counter(pages);
      font-family: -apple-system, Helvetica, sans-serif;
      font-size: 9pt;
      color: #666;
    }}
    @top-right {{
      content: "1ClickWebsite.ai — Reverse-Engineering Brief · 2026-07-06";
      font-family: -apple-system, Helvetica, sans-serif;
      font-size: 8pt;
      color: #999;
    }}
  }}
  html {{ font-size: 10.5pt; }}
  body {{
    font-family: -apple-system, "SF Pro Text", Helvetica, Arial, sans-serif;
    color: #1a1a1a;
    line-height: 1.45;
    max-width: 100%;
  }}
  h1 {{
    font-size: 22pt;
    font-weight: 800;
    margin: 0 0 4pt 0;
    padding-bottom: 6pt;
    border-bottom: 3px solid #2563eb;
    color: #0f172a;
  }}
  h2 {{
    font-size: 15pt;
    font-weight: 700;
    margin: 18pt 0 6pt 0;
    padding: 4pt 0 4pt 8pt;
    background: linear-gradient(90deg, #eff6ff 0%, transparent 100%);
    border-left: 4px solid #2563eb;
    color: #0f172a;
    page-break-after: avoid;
  }}
  h3 {{
    font-size: 12pt;
    font-weight: 700;
    margin: 12pt 0 4pt 0;
    color: #1e293b;
    page-break-after: avoid;
  }}
  h4 {{
    font-size: 11pt;
    font-weight: 600;
    margin: 8pt 0 3pt 0;
    color: #334155;
    page-break-after: avoid;
  }}
  p {{ margin: 0 0 6pt 0; }}
  hr {{ border: 0; border-top: 1px solid #e2e8f0; margin: 12pt 0; }}
  code {{
    background: #f1f5f9;
    padding: 1pt 4pt;
    border-radius: 3pt;
    font-family: "SF Mono", Menlo, monospace;
    font-size: 9pt;
    color: #be185d;
  }}
  pre {{
    background: #0f172a;
    color: #e2e8f0;
    padding: 8pt;
    border-radius: 4pt;
    overflow-x: auto;
    font-size: 8.5pt;
    line-height: 1.35;
    page-break-inside: avoid;
  }}
  pre code {{ background: transparent; color: inherit; padding: 0; }}
  table {{
    border-collapse: collapse;
    width: 100%;
    margin: 6pt 0;
    font-size: 9.5pt;
    page-break-inside: avoid;
  }}
  th, td {{
    border: 1px solid #cbd5e1;
    padding: 4pt 6pt;
    text-align: left;
    vertical-align: top;
  }}
  th {{
    background: #f1f5f9;
    font-weight: 700;
    color: #0f172a;
  }}
  tr:nth-child(even) td {{ background: #f8fafc; }}
  blockquote {{
    border-left: 3px solid #94a3b8;
    padding-left: 8pt;
    color: #475569;
    font-style: italic;
    margin: 6pt 0;
  }}
  ul, ol {{ margin: 4pt 0 6pt 16pt; padding: 0; }}
  li {{ margin: 2pt 0; }}
  strong {{ color: #0f172a; font-weight: 700; }}
  em {{ color: #475569; }}
  /* First-page header */
  body::before {{
    content: "";
    display: block;
    height: 0;
  }}
  /* Page break hints */
  h1, h2 {{ page-break-after: avoid; }}
  h2 + *, h3 + * {{ page-break-before: avoid; }}
</style>
</head>
<body>
{html_body}
</body>
</html>
"""

html_path.write_text(html_text := html_full, encoding="utf-8")
print(f"✓ wrote {html_path} ({len(html_text):,} bytes)")

# Now use Chrome headless to print to PDF
chrome = "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"
if not os.path.exists(chrome):
    print("Chrome not found at expected path", file=sys.stderr)
    sys.exit(1)

cmd = [
    chrome,
    "--headless=new",
    "--disable-gpu",
    "--no-sandbox",
    "--disable-dev-shm-usage",
    f"--print-to-pdf={pdf_path}",
    "--no-pdf-header-footer",
    "--print-to-pdf-no-header",
    f"file://{html_path}",
]

# Chrome's --no-pdf-header-footer already suppresses; but we have our own header/footer via @page
result = subprocess.run(cmd, capture_output=True, text=True, timeout=120)
print(f"chrome exit code: {result.returncode}")
if result.stderr.strip():
    print(f"chrome stderr (first 500 chars): {result.stderr[:500]}")

if pdf_path.exists():
    size = pdf_path.stat().st_size
    print(f"✓ wrote {pdf_path} ({size:,} bytes, {size/1024:.1f} KB)")
else:
    print(f"✗ PDF not created", file=sys.stderr)
    sys.exit(1)