"""metrics22.py <cam> <png>...: top-half mean HSV saturation; blue cover (p7/p8 W rects, pass-21 rule); green / red cover
(p7/p8 x 1000-1452 y 100-700, c2 x>800 y>400)."""
import sys, numpy as np
from PIL import Image
def sat(im): return np.asarray(im.convert("HSV"))[: im.height // 2, :, 1].mean()
def blue(im, box):
    a = np.asarray(im.convert("RGB")).astype(int)[box[1]:box[3], box[0]:box[2]]; r, g, b = a[..., 0], a[..., 1], a[..., 2]
    return ((b > r + 40) & (b > g + 20) & (b > 120)).mean() * 100
def hsv(im, box, kind, smin):
    a = np.asarray(im.convert("HSV")).astype(int)[box[1]:box[3], box[0]:box[2]]; h, s = a[..., 0], a[..., 1]
    m = ((h >= 43) & (h <= 102)) if kind == "g" else ((h <= 13) | (h >= 242))
    return (m & (s > smin)).mean() * 100
WB = {"p8_top": (0, 150, 420, 650), "p7_high": (0, 100, 450, 700)}
EB = {"p8_top": (1000, 100, 1452, 700), "p7_high": (1000, 100, 1452, 700), "c2_fountain": (800, 400, 1452, 793)}
cam = sys.argv[1]
for f in sys.argv[2:]:
    im = Image.open(f); s = f"{f[-28:]:28s} sat {sat(im):5.1f}"
    if cam in WB: s += f"  Wblue {blue(im, WB[cam]):4.1f}"
    if cam in EB: s += "  green " + "/".join(f"{hsv(im, EB[cam], 'g', t):4.1f}" for t in (0, 60, 90)) + "  red " + "/".join(f"{hsv(im, EB[cam], 'r', t):4.1f}" for t in (60, 100, 140))
    print(s)
