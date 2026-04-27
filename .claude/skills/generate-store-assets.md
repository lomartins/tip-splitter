---
name: generate-store-assets
description: Generate Google Play Store graphic assets (feature graphic + screenshots) from the HTML design source.
---

# Generate Store Assets

Render Play Store graphic assets from the design HTML source.

## What this produces

| File | Dimensions | Satisfies |
|------|-----------|-----------|
| `{lang}/feature_graphic.png` | 1024×500 | Recurso gráfico |
| `{lang}/screenshot_01-04.png` | 1080×1920 | Phone · Tablet 7" · Tablet 10" |

Both `pt` and `en` language variants.

## Steps

1. Verify source HTML exists at `assets/store/source/Play Store Screenshots.html`.
   - If missing, ask user to re-download from the original design URL.

2. Run the render script:
   ```bash
   python3 .claude/skills/scripts/render_screenshots.py
   ```
   Script uses `/usr/bin/google-chrome-stable` in headless mode.

3. Verify outputs:
   ```bash
   python3 -c "
   import struct, os
   def png_wh(p):
       d=open(p,'rb').read(24); return struct.unpack('>II',d[16:24])
   base='assets/store'
   for lang in ['pt','en']:
       for f in sorted(os.listdir(f'{base}/{lang}')):
           w,h=png_wh(f'{base}/{lang}/{f}')
           print(f'{lang}/{f}: {w}x{h}')
   "
   ```
   Expected: feature_graphic = 1024×500, screenshots = 1080×1920.

4. Visually inspect one screenshot and the feature graphic (use Read tool on .png files).

## Source file

`assets/store/source/Play Store Screenshots.html` — bilingual (PT/EN toggle), 4 screenshot frames + feature graphic.

## Notes

- Re-run after editing the source HTML to update outputs.
- All screenshot sizes satisfy Google Play constraints:
  - Phone: 320–3840 px each side ✓
  - Tablet 7": 320–3840 px each side ✓
  - Tablet 10": 1080–7680 px each side ✓ (short side = 1080 px)
- Tablet uploads can reuse the phone screenshots directly.
