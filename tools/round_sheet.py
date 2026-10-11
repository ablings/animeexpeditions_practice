"""Round comparison sheets from a reviewer's judged frames.
Usage: python tools/round_sheet.py <round> <pass> <average> cam=score,cam=score,...  -> out/cmp_r<round>a.jpg, b.jpg"""
import sys
from PIL import Image, ImageDraw, ImageFont
rnd, pas, avg, scs = sys.argv[1:5]
sc = dict(kv.split("=") for kv in scs.split(","))
cams = list(sc)
try: f = ImageFont.truetype("arialbd.ttf", 22)
except Exception: f = None
for part, cs in (("a", cams[:6]), ("b", cams[6:])):
    W, H = 642, 396; sh = Image.new("RGB", (W * 2, H * len(cs) + 40), "black"); d = ImageDraw.Draw(sh)
    d.text((8, 8), f"Round {rnd} (pass {pas}) - average {avg} - reference left, practice right", fill="white", font=f)
    for i, c in enumerate(cs):
        for j, k in enumerate(("ref", "rep")):
            sh.paste(Image.open(f"out/verify{rnd}/v{rnd}_{c}_{k}.jpg").convert("RGB").resize((W, H)), (j * W, 40 + i * H))
        d.text((8, 48 + i * H), f"{c}  score {sc[c]}", fill="yellow", font=f)
    sh.save(f"out/cmp_r{rnd}{part}.jpg", quality=82); print(f"out/cmp_r{rnd}{part}.jpg")
