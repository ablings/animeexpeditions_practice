"""sheet.py <tag> cam...: ref | rep(tag) side by side at half size -> out/r25w/sheet_<tag>.jpg"""
import sys
from PIL import Image
tag, cams = sys.argv[1], sys.argv[2:]
W, H = 726, 396; s = Image.new("RGB", (W * 2 + 6, (H + 4) * len(cams)))
for i, c in enumerate(cams):
    s.paste(Image.open(f"out/verify22/v22_{c}_ref.jpg").resize((W, H)), (0, i * (H + 4)))
    s.paste(Image.open(f"out/r25w/{tag}_{c}.png").convert("RGB").resize((W, H)), (W + 6, i * (H + 4)))
s.save(f"out/r25w/sheet_{tag}.jpg", quality=85)
