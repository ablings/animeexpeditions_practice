"""python out/r24w/box24.py <cam> <png>... : 5x5 means at the round-22 review boxes (verify22_plaza.md), (measure xy, target xy)
as box centres; target re-sampled from out/verify22/v22_<cam>_ref.jpg every run. Also top-half saturation and cover metrics."""
import sys, numpy as np
from PIL import Image
B = {
 "p1_spawn_n": {"band": ((620, 30),)*2, "fall": ((814, 112), (799, 66)), "bolHead": ((446, 502), (440, 500))},
 "p2_spawn_s": {"crown": ((902, 48), (594, 60)), "panel": ((658, 300),)*2, "door": ((712, 300), (724, 300))},
 "p3_spawn_e": {"skull": ((726, 34), (720, 40)), "glow": ((600, 220),)*2},
 "p4_spawn_w": {"ring": ((684, 318), (676, 297))},
 "p7_high": {"lawnS": ((900, 620),)*2},
 "p8_top": {"groundE": ((1102, 562), (1162, 528))},
 "c1_wall": {"tunnel": ((880, 470),)*2},
 "c2_fountain": {"fern": ((930, 590),)*2},
 "c3_pavilion": {"raid": ((1252, 302), (1350, 280))},
 "c4_stairs": {"tread": ((400, 690),)*2, "riser": ((430, 628), (430, 648)), "gold": ((616, 620), (640, 560)), "blue": ((660, 700),)*2, "sky": ((702, 62),)*2},
}
def m(im, x, y):
    a = np.asarray(im)[y - 2:y + 3, x - 2:x + 3].reshape(-1, 3).mean(0); return tuple(int(round(v)) for v in a)
def sat(im): return np.asarray(im.convert("HSV"))[: im.height // 2, :, 1].mean()
def blue(a): r, g, b = a[..., 0], a[..., 1], a[..., 2]; return ((b > r + 40) & (b > g + 20) & (b > 120)).mean() * 100
def hcov(im, box, kind, smin=60):
    a = np.asarray(im.convert("HSV")).astype(int)[box[1]:box[3], box[0]:box[2]]; h, s = a[..., 0], a[..., 1]
    mm = ((h >= 43) & (h <= 102)) if kind == "g" else ((h <= 13) | (h >= 242)); return (mm & (s > smin)).mean() * 100
WB = {"p8_top": (0, 150, 420, 650), "p7_high": (0, 100, 450, 700)}
EB = {"p8_top": (1000, 100, 1452, 700), "p7_high": (1000, 100, 1452, 700), "c2_fountain": (800, 400, 1452, 793)}
def metr(im, cam):
    s = f"sat {sat(im):5.1f}"
    if cam in WB: b = WB[cam]; s += f" Wblue {blue(np.asarray(im).astype(int)[b[1]:b[3], b[0]:b[2]]):4.1f}"
    if cam in EB: s += f" Egreen {hcov(im, EB[cam], 'g'):4.1f} Ered {hcov(im, EB[cam], 'r'):4.1f}"
    return s
cam = sys.argv[1]; Bx = B.get(cam, {})
ref = Image.open(f"out/verify22/v22_{cam}_ref.jpg").convert("RGB")
ims = [Image.open(f).convert("RGB") for f in sys.argv[2:]]
for k, (mx, tx) in Bx.items():
    T = m(ref, *tx); row = f"{k:9s} {str(T):15s}"
    for im in ims:
        v = m(im, *mx); d = max(abs(a - b) for a, b in zip(v, T)); row += f"  {str(v):15s}{d:4d}"
    print(row)
print("ref     ", metr(ref, cam))
for f, im in zip(sys.argv[2:], ims): print(f"{f[-22:]:22s}", metr(im, cam))
