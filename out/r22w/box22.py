"""python out/r22w/box22.py <cam> <png>... : 5x5 means at the round-19 review boxes (verify19_plaza.md). Each entry is
(measure xy, target xy); the target is re-sampled from out/verify19/v19_<cam>_ref.jpg on every run (never typed)."""
import sys
from PIL import Image
B = {
 "c1_wall": {"pods": ((688, 262),)*2, "pale": ((556, 340), (556, 351)), "tunnel": ((880, 480), (880, 470)),
             "slate": ((410, 352), (471, 351)), "ledge": ((560, 443), (560, 442))},
 "c2_fountain": {"grass": ((947, 489), (930, 590)), "grassR": ((930, 590),)*2},
 "c3_pavilion": {"raid": ((1350, 280),)*2},
 "c4_stairs": {"tread": ((400, 690),)*2, "riser": ((430, 655),)*2, "runner": ((660, 700),)*2, "pine": ((210, 400), (190, 410))},
 "p1_spawn_n": {"bolHead": ((447, 496), (440, 500)), "bolBase": ((447, 560), (440, 575))},
 "p2_spawn_s": {"lawn": ((560, 378),)*2},
 "p3_spawn_e": {"cheek": ((700, 85), (720, 80))},
 "p5_diag_ne": {"runner": ((150, 410),)*2, "rim": ((262, 500),)*2},
 "p7_high": {"basin": ((367, 543), (920, 470))},
 "p8_top": {"hole": ((957, 336), (990, 300))},
}
def m(im, x, y):
    px = [im.getpixel((x + i, y + j)) for i in range(-2, 3) for j in range(-2, 3)]
    return tuple(round(sum(p[k] for p in px) / 25) for k in range(3))
cam = sys.argv[1]; Bx = B.get(cam, {})
ref = Image.open(f"out/verify19/v19_{cam}_ref.jpg").convert("RGB")
files = sys.argv[2:]
ims = [Image.open(f).convert("RGB") for f in files]
print("box        target          " + "  ".join(f[-18:] for f in files))
for k, (mx, tx) in Bx.items():
    T = m(ref, *tx); row = f"{k:10s} {str(T):15s}"
    for im in ims:
        v = m(im, *mx); d = max(abs(a - b) for a, b in zip(v, T)); row += f"  {str(v):15s}{d:4d}"
    print(row)
