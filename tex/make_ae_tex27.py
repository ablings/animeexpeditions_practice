"""make_ae_tex27.py: pass-27 desaturated leaf spray maps from our own pass-14 maps (tex/leaf14/leaf14_spray_<fam>.png).
HSV: saturation x SAT, value x VAL (clipped), alpha kept. Writes tex/leaf27/<tag>_spray_<fam>.png. Usage: make_ae_tex27.py [SAT VAL TAG]; leaf27 = 0.75 1.10, leaf27b = 0.62 1.12."""
import sys, numpy as np
from PIL import Image
SAT, VAL = float(sys.argv[1]) if len(sys.argv) > 1 else 0.75, float(sys.argv[2]) if len(sys.argv) > 2 else 1.10
TAG = sys.argv[3] if len(sys.argv) > 3 else "leaf27"
for fam in ("blue", "gold", "purple"):
    im = Image.open(f"tex/leaf14/leaf14_spray_{fam}.png").convert("RGBA"); a = im.split()[3]
    hsv = np.asarray(im.convert("RGB").convert("HSV")).astype(float)
    hsv[..., 1] *= SAT; hsv[..., 2] = np.clip(hsv[..., 2] * VAL, 0, 255)
    out = Image.fromarray(hsv.astype(np.uint8), "HSV").convert("RGB"); out.putalpha(a)
    out.save(f"tex/leaf27/{TAG}_spray_{fam}.png")
    m = np.asarray(a) > 128; print(fam, np.asarray(out.convert("RGB"))[m].mean(0).round())
