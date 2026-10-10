"""Side-by-side sheets: reference (left) vs practice (right) per camera, plus median-luma per pair.
Usage: python tools/compare_sheet.py <ref_dir> <mine_dir> <mine_tag> <out.jpg> [cams,...]"""
import sys, json, os
from PIL import Image, ImageDraw, ImageStat
rd, md, tag, outp = sys.argv[1:5]
cams = [k for k in json.load(open("cams.json")) if not k.startswith("_")]
if len(sys.argv) > 5: cams = sys.argv[5].split(",")
s = 0.32; rows = []
for c in cams:
    a = os.path.join(rd, f"ref_{c}.png"); b = os.path.join(md, f"{tag}_{c}.png")
    if os.path.exists(a) and os.path.exists(b): rows.append((c, Image.open(a).convert("RGB"), Image.open(b).convert("RGB")))
w, h = rows[0][1].size; W, H = int(w * s), int(h * s)
sheet = Image.new("RGB", (W * 2, H * len(rows)), "black"); d = ImageDraw.Draw(sheet)
for i, (c, a, b) in enumerate(rows):
    sheet.paste(a.resize((W, H)), (0, i * H)); sheet.paste(b.resize((W, H)), (W, i * H))
    la = ImageStat.Stat(a.convert("L")).median[0]; lb = ImageStat.Stat(b.convert("L")).median[0]
    d.text((4, i * H + 4), f"{c} REF median {la}", fill="yellow"); d.text((W + 4, i * H + 4), f"{tag} median {lb}", fill="yellow")
sheet.save(outp, quality=80); print(outp, len(rows))
