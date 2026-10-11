"""python out/r20w/box20.py <cam> <png>... : 5x5 means at the round-17 review boxes. Each entry is (measure xy, target xy):
the target is re-sampled from out/verify17/v17_<cam>_ref.jpg on every run (never typed)."""
import sys
from PIL import Image
B = {
 "p3_spawn_e": {"door": ((695, 300),)*2, "tower": ((850, 170),)*2, "haze": ((645, 175),)*2, "ember": ((700, 378),)*2},
 "c1_wall": {"interior": ((540, 440), (880, 470)), "interior2": ((600, 400), (600, 400)), "splash": ((720, 430),)*2,
             "splatL": ((340, 670),)*2, "splatR": ((1120, 630),)*2},
 "p5_diag_ne": {"bolHead": ((720, 545),)*2, "bolBase": ((720, 640),)*2, "interior": ((720, 400),)*2},
 "c4_stairs": {"treads": ((300, 560),)*2, "riser": ((400, 520),)*2, "pine": ((190, 410),)*2, "cypress": ((315, 300),)*2},
 "p1_spawn_n": {"interior": ((200, 400), (250, 300))},
 "p2_spawn_s": {"lawn": ((560, 378),)*2},
 "p7_high": {"beach": ((380, 640),)*2, "basin": ((380, 540),)*2},
 "p8_top": {"basin": ((560, 250),)*2, "greenhole": ((990, 300),)*2},
 "c2_fountain": {"grass": ((930, 590),)*2, "archface": ((640, 290),)*2},
 "c3_pavilion": {"haze": ((1380, 220), (1350, 280))},
}
def m(im, x, y):
    px = [im.getpixel((x + i, y + j)) for i in range(-2, 3) for j in range(-2, 3)]
    return tuple(round(sum(p[k] for p in px) / 25) for k in range(3))
cam = sys.argv[1]; Bx = B.get(cam, {})
ref = Image.open(f"out/verify17/v17_{cam}_ref.jpg").convert("RGB")
files = sys.argv[2:]
ims = [Image.open(f).convert("RGB") for f in files]
print("box        target          " + "  ".join(f[-18:] for f in files))
for k, (mx, tx) in Bx.items():
    T = m(ref, *tx); row = f"{k:10s} {str(T):15s}"
    for im in ims:
        v = m(im, *mx); d = max(abs(a - b) for a, b in zip(v, T)); row += f"  {str(v):15s}{d:4d}"
    print(row)
