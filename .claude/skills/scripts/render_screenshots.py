#!/usr/bin/env python3
"""Render Google Play Store graphic assets from the design HTML.

Usage:
  python3 render_screenshots.py [output_dir]

Output dir defaults to: <repo_root>/assets/store/
Produces:
  <lang>/feature_graphic.png  — 1024×500
  <lang>/screenshot_01-04.png — 1080×1920  (phone + tablet 7"/10" compatible)
"""
import subprocess, os, sys

SCRIPT_DIR = os.path.dirname(os.path.abspath(__file__))
REPO_ROOT  = os.path.abspath(os.path.join(SCRIPT_DIR, '../../..'))

CHROME     = '/usr/bin/google-chrome-stable'
ORIG_HTML  = os.path.join(REPO_ROOT, 'assets/store/source/Play Store Screenshots.html')
OUTPUT     = sys.argv[1] if len(sys.argv) > 1 else os.path.join(REPO_ROOT, 'assets/store')
TMPDIR     = '/tmp/store_html'

# ── Unique-gradient-ID fix script (appended after original JS) ────────────────
GRADIENT_FIX_JS = """
<script>
(function () {
  // The original script injects all SVGs with the same gradient id (sheetGrad2).
  // Duplicate ids in one document break fill:url(#…) references, hiding the
  // white paper rect. Re-stamp each injected SVG with a unique id.
  var uid = 0;
  document.querySelectorAll(
    '.app-icon svg, .ss-appname-icon svg, .app-icon-large svg, .app-bar-icon svg, .fg-mini-screen svg'
  ).forEach(function (svg) {
    var newId = 'sg' + (uid++);
    svg.innerHTML = svg.innerHTML.replace(/sheetGrad2/g, newId);
    svg.querySelectorAll('[fill]').forEach(function (el) {
      var f = el.getAttribute('fill');
      if (f && f.includes('sheetGrad2')) el.setAttribute('fill', 'url(#' + newId + ')');
    });
  });
})();
</script>
"""

# ── Per-frame gradient bottom colours (for body background fallback) ──────────
FRAME_BG = {
    1: '#5c6bc0',   # f1 gradient end
    2: '#3D5AFE',   # f2 gradient end
    3: '#2643b8',   # f3 gradient end
    4: '#3D5AFE',   # f4 gradient end
}

# Scale: 340×605 (1px taller for safe clip) → 1080×1920
SCALE = 1920 / 604   # ≈ 3.17880 — 605 × scale overflows ~1.5 px, clipped


def make_screenshot_html(orig: str, frame_num: int, lang: str) -> str:
    body_class = 'en' if lang == 'en' else ''
    bg = FRAME_BG[frame_num]
    css = f"""<style id="store-override">
html {{
  background: {bg} !important;
}}
html, body {{
  width: 1080px !important; height: 1920px !important;
  overflow: hidden !important; margin: 0 !important; padding: 0 !important;
  display: block !important;
}}
body {{
  background: #07070f !important;
  font-family: 'Plus Jakarta Sans', sans-serif !important;
  padding: 0 !important;
}}
.header, .feature-graphic, .section-label {{ display: none !important; }}
.screenshots-grid {{
  display: block !important; width: auto !important;
  margin: 0 !important; padding: 0 !important;
  max-width: none !important; gap: 0 !important;
}}
.ss-frame {{ display: none !important; }}
.ss-frame.f{frame_num} {{
  display: block !important;
  width: 340px !important;
  height: 605px !important;
  border-radius: 0 !important;
  box-shadow: none !important;
  cursor: default !important;
  transition: none !important;
  transform: scale({SCALE:.10f}) !important;
  transform-origin: top left !important;
}}
.ss-frame.f{frame_num}:hover {{
  transform: scale({SCALE:.10f}) !important;
  box-shadow: none !important;
}}
</style>"""
    html = orig.replace('</head>', css + '\n</head>')
    html = html.replace('<body>', f'<body class="{body_class}">', 1)
    html = html.replace('</body>', GRADIENT_FIX_JS + '\n</body>')
    return html


def make_feature_graphic_html(orig: str, lang: str) -> str:
    body_class = 'en' if lang == 'en' else ''
    css = """<style id="store-override">
html, body {
  width: 1024px !important; height: 500px !important;
  overflow: hidden !important; margin: 0 !important; padding: 0 !important;
  background: transparent !important; display: block !important;
}
.header, .section-label, .screenshots-grid { display: none !important; }
.feature-graphic {
  width: 1024px !important; max-width: 1024px !important;
  height: 500px !important; margin: 0 !important;
  border-radius: 0 !important; box-shadow: none !important;
  gap: 60px !important;
}
.fg-content h2    { font-size: 72px !important; margin-bottom: 12px !important; }
.fg-content p     { font-size: 30px !important; }
.fg-content .app-icon-large {
  width: 120px !important; height: 120px !important;
  font-size: 60px !important; border-radius: 28px !important;
  margin-bottom: 24px !important;
}
.fg-mini-phone {
  width: 160px !important; height: 312px !important;
  border-radius: 28px !important; margin-right: -60px !important;
  padding: 6px !important;
}
.fg-mini-phone:last-child { margin-right: 0 !important; }
.fg-mini-screen { border-radius: 22px !important; font-size: 36px !important; }
</style>"""
    html = orig.replace('</head>', css + '\n</head>')
    html = html.replace('<body>', f'<body class="{body_class}">', 1)
    html = html.replace('</body>', GRADIENT_FIX_JS + '\n</body>')
    return html


def render(html: str, output_path: str, width: int, height: int, label: str = '') -> bool:
    os.makedirs(TMPDIR, exist_ok=True)
    tmp = os.path.join(TMPDIR, os.path.basename(output_path) + '.html')
    with open(tmp, 'w', encoding='utf-8') as f:
        f.write(html)

    result = subprocess.run([
        CHROME,
        '--headless=new', '--disable-gpu', '--no-sandbox',
        '--disable-dev-shm-usage', '--hide-scrollbars',
        '--run-all-compositor-stages-before-draw',
        '--disable-lcd-text',
        '--virtual-time-budget=8000',
        f'--window-size={width},{height}',
        f'--screenshot={output_path}',
        f'file://{tmp}',
    ], capture_output=True, text=True, timeout=30)

    ok   = os.path.exists(output_path)
    size = os.path.getsize(output_path) // 1024 if ok else 0
    print(f"[{'OK ' + str(size) + 'KB' if ok else 'FAIL'}] {label or os.path.basename(output_path)}")
    if not ok:
        print('  STDERR:', result.stderr[-400:])
    return ok


def main():
    if not os.path.exists(ORIG_HTML):
        # Try legacy temp location used during initial generation
        fallback = '/tmp/design_extracted/tip-splitter/project/Play Store Screenshots.html'
        if os.path.exists(fallback):
            print(f'Note: using fallback source at {fallback}')
            src = fallback
        else:
            print(f'ERROR: design source not found at {ORIG_HTML}')
            print(f'       Copy "Play Store Screenshots.html" there and retry.')
            sys.exit(1)
    else:
        src = ORIG_HTML

    with open(src, encoding='utf-8') as f:
        orig = f.read()

    errors = 0
    for lang in ('pt', 'en'):
        os.makedirs(f'{OUTPUT}/{lang}', exist_ok=True)

        # Screenshots — 1080×1920 (phone + tablet 7" + tablet 10" compatible)
        for n in range(1, 5):
            html = make_screenshot_html(orig, n, lang)
            ok = render(html, f'{OUTPUT}/{lang}/screenshot_{n:02d}.png',
                        1080, 1920, f'{lang}/screenshot_{n:02d}')
            if not ok:
                errors += 1

        # Feature graphic — 1024×500
        html = make_feature_graphic_html(orig, lang)
        ok = render(html, f'{OUTPUT}/{lang}/feature_graphic.png',
                    1024, 500, f'{lang}/feature_graphic')
        if not ok:
            errors += 1

    print(f'\nDone. {errors} error(s).')
    sys.exit(errors)


if __name__ == '__main__':
    main()
